import functions_framework

@functions_framework.http
def hello_http(request):
    return """
    <!DOCTYPE html>
    <html>
    <head>
        <title>Cloud Run Function</title>
    </head>
    <body>
        <h1>This is a Cloud Run function application</h1>
    </body>
    </html>
    """
