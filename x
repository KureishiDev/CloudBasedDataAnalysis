

import json
import boto3  # For AWS services (replace with Azure/GCP equivalents)
import pandas as pd
import io

def lambda_handler(event, context):
    """
    Handles log processing from S3, transforms data, and potentially loads to another service.
    """

    s3 = boto3.client('s3')
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']

    try:
        response = s3.get_object(Bucket=bucket, Key=key)
        log_content = response['Body'].read().decode('utf-8')

        # Example: Assume log data is in JSON lines format
        log_lines = log_content.strip().split('\n')
        log_data = [json.loads(line) for line in log_lines]

        df = pd.DataFrame(log_data)

        # Example: Basic data transformation (add more as needed)
        df['timestamp'] = pd.to_datetime(df['timestamp'])
        df['response_time'] = pd.to_numeric(df['response_time'], errors='coerce') # convert to number

        # Example: Simple analysis (e.g., average response time)
        avg_response_time = df['response_time'].mean()
        print(f"Average Response Time: {avg_response_time}")

        # --- Example: Load transformed data to another location (e.g., S3 as CSV) ---
        csv_buffer = io.StringIO()
        df.to_csv(csv_buffer, index=False)
        s3.put_object(Bucket='transformed-data-bucket', Key='transformed_logs.csv', Body=csv_buffer.getvalue())

        return {
            'statusCode': 200,
            'body': json.dumps('Log processing successful!')
        }

    except Exception as e:
        print(f"Error processing log file: {e}")
        return {
            'statusCode': 500,
            'body': json.dumps(f'Error: {e}')
        }



SELECT
    DATE_TRUNC('hour', timestamp) AS hour,
    COUNT(*) AS request_count,
    AVG(response_time) AS avg_response_time
FROM
    application_logs
WHERE
    timestamp >= TIMESTAMP '2023-01-01 00:00:00'
GROUP BY
    hour
ORDER BY
    hour;

SELECT
    DATE_TRUNC('day', timestamp) AS day,
    COUNT(CASE WHEN status_code >= 400 THEN 1 ELSE NULL END) AS error_count,
    COUNT(*) AS total_requests,
    (COUNT(CASE WHEN status_code >= 400 THEN 1 ELSE NULL END) * 1.0 / COUNT(*)) AS error_rate
FROM
    application_logs
GROUP BY
    day
ORDER BY
    day;
"""

