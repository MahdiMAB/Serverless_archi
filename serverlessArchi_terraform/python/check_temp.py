import json
import logging


logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    try:
        # recuperer les info from json file envoyer par le client 
        body = json.loads(event.get('body', '{}'))
        engine_id = body.get('engine_id', 'Unknown')
        temperature = body.get('temperature', 0)
        
        # check de temperature si ca depasse le seuil 
        status = "NORMAL"
        if temperature > 500:
            status = "CRITICAL_TEMPERATURE"
            logger.warning(f"ALERTE !! : Surchauffe détectée pour le moteur {engine_id}")

        # 3. Log pour CloudWatch
        logger.info(json.dumps({
            "service": "engine-analysis",
            "engine_id": engine_id,
            "temperature": temperature,
            "status": status
        }))

        # Construction de la réponse pour l'envoyer au API GW
        response_body = {
            "message": "Données traitées",
            "engine": engine_id,
            "status": status,
            "processed_temp": temperature
        }
        
        return {
            "statusCode": 200,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps(response_body)
        }

    except Exception as e:
        logger.error(f"Erreur : {str(e)}")
        return {
            "statusCode": 400,
            "body": json.dumps({"error": "JSON invalide ou données manquantes"})
        }
