import os
from google.cloud import storage

def list_folders(request):
    """Gera um index.html listando todas as pastas com data/hora no bucket."""
    bucket_name = os.environ.get("BUCKET_NAME", "meridian-mmm")
    storage_client = storage.Client()
    bucket = storage_client.bucket(bucket_name)

    blobs = storage_client.list_blobs(bucket_name, delimiter="/")

    folders = set()
    for blob in blobs:
        path_parts = blob.name.split("/")
        if len(path_parts) > 1:
            folders.add(path_parts[0])

    html_content = "<html><body><h1>Treinamentos</h1><ul>"
    for folder in sorted(folders, reverse=True):  # Ordena por data/hora
        html_content += f'<li><a href="https://storage.googleapis.com/{bucket_name}/{folder}/summary.html">{folder}</a></li>'
    html_content += "</ul></body></html>"

    blob = bucket.blob("index.html")
    blob.upload_from_string(html_content, content_type="text/html")

    return "index.html atualizado!", 200
