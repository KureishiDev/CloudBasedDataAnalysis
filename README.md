# Log Processing and Analysis with AWS Lambda and SQL Queries

## Overview
This project demonstrates a log processing pipeline using an AWS Lambda function that ingests logs from an S3 bucket, transforms the data using Pandas, and optionally saves the transformed data back to S3. Additionally, SQL queries are provided for further analysis of the transformed data.

## Technologies Used
- **Python** (with libraries: `boto3`, `pandas`, `io`)
- **AWS Lambda** (Serverless log processing)
- **AWS S3** (Storage for raw and processed logs)
- **SQL** (For querying transformed data)

## Files
- `lambda_function.py`: The Lambda function code.
- `README.md`: This documentation file.

## Lambda Function Code
The Lambda function fetches log data from S3, transforms it using Pandas, and stores the transformed data as a CSV back to S3.

### Requirements
Install dependencies locally before deploying:
```bash
pip install boto3 pandas
```

### Example Usage
The Lambda function expects logs to be in a JSON lines format (one JSON object per line). The processed data will be saved as a CSV file to another S3 bucket (`transformed-data-bucket`).

### Deployment
Deploy the Lambda function via AWS Management Console or using AWS CLI/Serverless Framework. Ensure the Lambda has permission to read from the source S3 bucket and write to the target bucket.

## SQL Analysis Queries

### 1. Average Response Time per Hour
```sql
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
```
This query aggregates logs by hour to calculate the average response time and request count per hour.

### 2. Daily Error Rate Analysis
```sql
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
```
This query provides daily error counts, total requests, and error rates.

## Error Handling
The Lambda function catches all exceptions and returns a status code of 500 with the error message for debugging.

## Improvements to Consider
- Adding automated tests for validation.
- Incorporating real-time data processing with AWS Kinesis.
- Enhancing error logging for better troubleshooting.
- Expanding data transformation logic for more complex analysis.

