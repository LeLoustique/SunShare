"""Contrats du schéma OpenAPI dont dépend le client Dart généré."""

from app.main import app


def test_aucun_parametre_de_requete_facultatif_n_est_nullable():
    """Un paramètre facultatif décrit `anyOf [type, null]` est envoyé vide par le client dart-dio
    (`loop_id=`), ce que FastAPI refuse (422). Il doit être facultatif, sans `null` dans le schéma
    (`WithJsonSchema`)."""
    nullable = [
        f"{method.upper()} {path} : {parameter['name']}"
        for path, methods in app.openapi()["paths"].items()
        for method, operation in methods.items()
        for parameter in operation.get("parameters", [])
        if parameter["in"] == "query"
        and not parameter.get("required")
        and "anyOf" in parameter["schema"]
    ]
    assert nullable == []
