import json
import logging

# Configuration du logger pour voir ce qui se passe dans CloudWatch
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    logger.info(f"Événement reçu : {json.dumps(event)}")
    
    try:
        # 1. Extraction des données (API Gateway envoie tout dans 'body' sous forme de string)
        body = json.loads(event.get('body', '{}'))
        engine_id = body.get('engine_id', 'Unknown')
        temperature = body.get('temperature', 0)
        
        # 2. Logique métier "Safran"
        status = "NORMAL"
        if temperature > 500:
            status = "CRITICAL_OVERHEAT"
            logger.warning(f"ALERTE : Surchauffe détectée sur le moteur {engine_id}!")

        # 3. Réponse formatée pour API Gateway (Integration Proxy)
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
            "body": json.dumps({"error": "Format JSON invalide ou données manquantes"})
        }