/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package shop.JDBC;

/**
 *
 * @author admin
 */
import shop.constant.ServerConnectionInfo;
import shop.anotation.*;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public abstract class GenericDAO<T, K> implements BaseDAO<T, K> {

    private final String tableName;
    private final Connection connection;
    private final Class<T> entityClass;

    public GenericDAO(Class<T> entityClass) {
        this.entityClass = entityClass;
        this.tableName = "`" + getTableName(entityClass) + "`"; // MySQL sử dụng backticks
        this.connection = ServerConnectionInfo.CONNECTION;
    }

    private String getTableName(Class<T> entityClass) {
        if (entityClass.isAnnotationPresent(Table.class)) {
            return entityClass.getAnnotation(Table.class).name();
        }
        throw new IllegalArgumentException("Entity " + entityClass.getSimpleName() + " must have @Table annotation");
    }

    private String getKeyFieldName() {
        for (Field field : entityClass.getDeclaredFields()) {
            if (field.isAnnotationPresent(Id.class)) {
                return "`" + field.getAnnotation(Column.class).name() + "`"; // Thêm backticks cho column names
            }
        }
        return null;
    }

    protected String getInsertQuery() {
        StringBuilder sql = new StringBuilder("INSERT INTO " + tableName + " (");
        StringBuilder values = new StringBuilder(" VALUES (");

        for (Field field : entityClass.getDeclaredFields()) {
            if (field.isAnnotationPresent(Column.class) && !field.isAnnotationPresent(Id.class)) {
                sql.append("`").append(field.getAnnotation(Column.class).name()).append("`").append(", ");
                values.append("?, ");
            }
        }

        sql.setLength(sql.length() - 2);
        values.setLength(values.length() - 2);
        sql.append(")").append(values).append(")");

        return sql.toString();
    }

    protected String getUpdateQuery() {
        StringBuilder sql = new StringBuilder("UPDATE " + tableName + " SET ");
        String location = " WHERE " + getKeyFieldName() + " = ?";
        for (Field field : entityClass.getDeclaredFields()) {
            if (field.isAnnotationPresent(Column.class) && !field.isAnnotationPresent(Id.class)) {
                sql.append("`").append(field.getAnnotation(Column.class).name()).append("`").append(" = ?, ");
            }
        }
        sql.setLength(sql.length() - 2);
        sql.append(location);
        return sql.toString();
    }

    protected void setInsertParams(PreparedStatement stmt, T t) throws SQLException {
        int index = 1;
        try {
            for (Field field : entityClass.getDeclaredFields()) {
                if (field.isAnnotationPresent(Column.class) && !field.isAnnotationPresent(Id.class)) {
                    field.setAccessible(true);
                    Object value = field.get(t);

                    setParameterValue(stmt, index++, value, field);
                }
            }
        } catch (IllegalAccessException e) {
            throw new SQLException("Error setting insert parameters", e);
        }
    }

    protected void setUpdateParams(PreparedStatement stmt, T t) throws SQLException {
        int index = 1;
        try {
            Field idField = null;
            for (Field field : entityClass.getDeclaredFields()) {
                field.setAccessible(true);
                if (field.isAnnotationPresent(Id.class)) {
                    idField = field;
                }
                if (field.isAnnotationPresent(Column.class) && !field.isAnnotationPresent(Id.class)) {
                    Object value = field.get(t);
                    setParameterValue(stmt, index++, value, field);
                }
            }
            if (idField == null) {
                throw new SQLException("Error setting update parameters - No ID field found");
            }
            stmt.setObject(index, idField.get(t));
        } catch (IllegalAccessException e) {
            throw new SQLException("Error setting update parameters", e);
        }
    }

    /**
     * Xử lý việc set parameter cho PreparedStatement với hỗ trợ ENUM
     */
    private void setParameterValue(PreparedStatement stmt, int index, Object value, Field field) throws SQLException {
        if (value == null) {
            stmt.setNull(index, Types.NULL);
        } else if (value instanceof java.util.Date) {
            stmt.setTimestamp(index, new Timestamp(((java.util.Date) value).getTime()));
        } else if (value instanceof Boolean) {
            stmt.setBoolean(index, (Boolean) value);
        } else if (value instanceof String && isEnumField(field)) {
            // Xử lý ENUM - set as String cho MySQL ENUM
            stmt.setString(index, (String) value);
        } else {
            stmt.setObject(index, value);
        }
    }

    /**
     * Kiểm tra xem field có phải là ENUM không dựa trên annotation @Enumerated
     */
    private boolean isEnumField(Field field) {
        // Kiểm tra annotation @Enumerated
        return field.isAnnotationPresent(Enumerated.class);
    }

    @Override
    public boolean insert(T t) throws SQLException {
        String sql = getInsertQuery();
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            setInsertParams(stmt, t);
            return stmt.executeUpdate() > 0;
        }
    }

    @Override
    public K insertGetKey(T t) throws SQLException {
        String sql = getInsertQuery();
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            setInsertParams(stmt, t);
            if (stmt.executeUpdate() > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    Object key = (K) rs.getObject(1);
                    // Chuyển đổi kiểu khóa chính dựa vào kiểu thực tế của nó
                    if (key instanceof BigDecimal) {
                        Integer key_int = ((BigDecimal) key).intValueExact();
                        return (K) key_int; // Nếu là Integer
                    } else if (key instanceof BigInteger) {
                        Integer key_int = ((BigInteger) key).intValueExact();
                        return (K) key_int;
                    } else if (key instanceof String) {
                        return (K) key; // Nếu là String
                    } else {
                        throw new SQLException("Không thể xử lý kiểu của khóa chính: " + key.getClass().getName());
                    }
                }
            }
            return null;
        }
    }

    @Override
    public List<T> getAll() throws SQLException {
        String sql = "SELECT * FROM " + tableName;
        List<T> data = new ArrayList<>();
        try (PreparedStatement stmt = connection.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                data.add(mapRow(rs));
            }
            return data;
        }
    }

    @Override
    public boolean update(T t) throws SQLException {
        String sql = getUpdateQuery();
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            setUpdateParams(stmt, t);
            return stmt.executeUpdate() > 0;
        }
    }

    @Override
    public T getById(K id) throws SQLException {
        String sql = "SELECT * FROM " + tableName + " WHERE " + getKeyFieldName() + " = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setObject(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }

    @Override
    public boolean deleteById(K id) throws SQLException {
        String sql = "DELETE FROM " + tableName + " WHERE " + getKeyFieldName() + " = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setObject(1, id);
            return stmt.executeUpdate() > 0;
        }
    }

    public List<T> findByOr(Object... params) throws SQLException {
        String[] columnNames = getColumnNamesFromAnnotation();

        validateParams(columnNames, params);

        String sql = "SELECT * FROM " + tableName + " WHERE ";
        StringBuilder operations = new StringBuilder();
        for (int i = 0; i < columnNames.length; i++) {
            operations.append("`").append(columnNames[i]).append("` = ?");
            if (i < columnNames.length - 1) {
                operations.append(" OR ");
            }
        }
        sql = sql + operations.toString();

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            setQueryParams(stmt, params);
            try (ResultSet rs = stmt.executeQuery()) {
                List<T> results = new ArrayList<>();
                while (rs.next()) {
                    results.add(mapRow(rs));
                }
                return results;
            }
        }
    }

    public List<T> findByAnd(Object... params) throws SQLException {
        String[] columnNames = getColumnNamesFromAnnotation();

        validateParams(columnNames, params);

        String sql = "SELECT * FROM " + tableName + " WHERE ";
        StringBuilder operations = new StringBuilder();
        for (int i = 0; i < columnNames.length; i++) {
            operations.append("`").append(columnNames[i]).append("` = ?");
            if (i < columnNames.length - 1) {
                operations.append(" AND ");
            }
        }
        sql = sql + operations.toString();

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            setQueryParams(stmt, params);
            try (ResultSet rs = stmt.executeQuery()) {
                List<T> results = new ArrayList<>();
                while (rs.next()) {
                    results.add(mapRow(rs));
                }
                return results;
            }
        }
    }

    public List<T> executeQueryFind(Object... params) throws SQLException {
        String querySql = getQueryFromAnnotation();

        try (PreparedStatement stmt = connection.prepareStatement(querySql)) {
            setQueryParams(stmt, params);
            try (ResultSet rs = stmt.executeQuery()) {
                List<T> results = new ArrayList<>();
                while (rs.next()) {
                    results.add(mapRow(rs));
                }
                return results;
            }
        }
    }

    public boolean executeQueryUpdateOrCheck(Object... params) throws SQLException {
        String querySql = getQueryFromAnnotation();

        try (PreparedStatement stmt = connection.prepareStatement(querySql)) {
            setQueryParams(stmt, params);
            return stmt.executeUpdate() > 0;
        }
    }

    // Helper methods
    private String[] getColumnNamesFromAnnotation() {
        StackTraceElement[] stackTrace = Thread.currentThread().getStackTrace();
        String methodName = stackTrace[3].getMethodName(); // Điều chỉnh index để lấy đúng method
        Method[] methods = this.getClass().getMethods();

        for (Method method : methods) {
            if (method.isAnnotationPresent(FindBy.class) && method.getName().equals(methodName)) {
                return method.getAnnotation(FindBy.class).columns();
            }
        }
        throw new IllegalArgumentException("No method found with @FindBy annotation for method: " + methodName);
    }

    private String getQueryFromAnnotation() {
        StackTraceElement[] stackTrace = Thread.currentThread().getStackTrace();
        String methodName = stackTrace[3].getMethodName(); // Điều chỉnh index để lấy đúng method
        Method[] methods = this.getClass().getMethods();

        for (Method method : methods) {
            if (method.isAnnotationPresent(Query.class) && method.getName().equals(methodName)) {
                return method.getAnnotation(Query.class).sql();
            }
        }
        throw new IllegalArgumentException("No method found with @Query annotation for method: " + methodName);
    }

    private void validateParams(String[] columnNames, Object[] params) {
        if (columnNames.length > params.length) {
            throw new IllegalArgumentException("Not enough params for this query. Expected: " + columnNames.length + ", Got: " + params.length);
        }
        if (columnNames.length < params.length) {
            throw new IllegalArgumentException("Too many parameters. Expected: " + columnNames.length + ", Got: " + params.length);
        }
    }

    private void setQueryParams(PreparedStatement stmt, Object[] params) throws SQLException {
        for (int i = 0; i < params.length; i++) {
            Object param = params[i];
            if (param instanceof java.util.Date) {
                stmt.setTimestamp(i + 1, new Timestamp(((java.util.Date) param).getTime()));
            } else if (param instanceof Boolean) {
                stmt.setBoolean(i + 1, (Boolean) param);
            } else if (param instanceof String) {
                // String có thể là ENUM value
                stmt.setString(i + 1, (String) param);
            } else {
                stmt.setObject(i + 1, param);
            }
        }
    }

    @Override
    public T mapRow(ResultSet rs) throws SQLException {
        try {
            T obj = entityClass.getDeclaredConstructor().newInstance();
            for (Field field : entityClass.getDeclaredFields()) {
                if (field.isAnnotationPresent(Column.class)) {
                    field.setAccessible(true);
                    String columnName = field.getAnnotation(Column.class).name();
                    Object value = rs.getObject(columnName);

                    // Xử lý mapping đặc biệt cho MySQL
                    if (value != null) {
                        // Xử lý Boolean từ TINYINT(1)
                        if (field.getType() == Boolean.class || field.getType() == boolean.class) {
                            if (value instanceof Number) {
                                value = ((Number) value).intValue() != 0;
                            }
                        } // Xử lý Date/Timestamp
                        else if (field.getType() == java.util.Date.class && value instanceof Timestamp) {
                            value = new java.util.Date(((Timestamp) value).getTime());
                        } // Xử lý ENUM - MySQL ENUM được trả về dưới dạng String
                        else if (field.getType() == String.class && isEnumField(field)) {
                            // MySQL ENUM đã được trả về dưới dạng String, không cần xử lý thêm
                            value = value.toString();
                        } // Xử lý trường hợp ENUM khác (nếu value không phải String nhưng field là String ENUM)
                        else if (field.getType() == String.class && !(value instanceof String) && isEnumField(field)) {
                            value = value.toString();
                        }
                    }

                    field.set(obj, value);
                }
            }
            return obj;
        } catch (Exception e) {
            throw new SQLException("Error mapping row to entity: " + entityClass.getSimpleName(), e);
        }
    }
}
