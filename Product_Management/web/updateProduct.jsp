<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Insert Product</title>
    <link rel="stylesheet" href="">
</head>

<body>
    <div class="container">
        <h2>Insert Product</h2>
        <form>
            <div class="mb-3">
                <label class="form-label">Name</label>
                <input type="text" class="form-control" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Brand</label>
                <input type="text" class="form-control" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Category</label>
                <input type="text" class="form-control" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Price</label>
                <input type="text" class="form-control" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Stock</label>
                <input type="text" class="form-control" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Image url</label>
                <input type="text" class="form-control" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Description</label>
                <input type="text" class="form-control">
            </div>
            <div class="mb-3">
                <label class="form-label">Spec description</label>
                <input type="text" class="form-control">
            </div>
            <div class="mb-3">
                <label>
                    Status
                </label>
                <label>
                    <input type="radio" name="option" value="1"> Option 1
                </label>
                <label>
                    <input type="radio" name="option" value="2"> Option 2
                </label>
            </div>
            <button type="submit" class="btn btn-primary">Submit</button>
        </form>
    </div>
</body>

</html>