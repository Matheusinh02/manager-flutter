const { DynamoDBClient } = require('@aws-sdk/client-dynamodb');
const { DynamoDBDocumentClient, ScanCommand } = require('@aws-sdk/lib-dynamodb');

// Configuração para LocalStack
const isLocal = process.env.AWS_SAM_LOCAL || process.env.IS_OFFLINE;
const dynamoConfig = isLocal ? {
  region: 'us-east-1',
  endpoint: 'http://localhost:4566',
  credentials: {
    accessKeyId: 'test',
    secretAccessKey: 'test'
  }
} : { region: 'us-east-1' };

const dynamoClient = new DynamoDBClient(dynamoConfig);
const docClient = DynamoDBDocumentClient.from(dynamoClient);

/**
 * READ ALL - Listar todos os items
 */
module.exports.handler = async (event) => {
  console.log('📋 LIST Items - Event:', JSON.stringify(event, null, 2));

  try {
    const result = await docClient.send(new ScanCommand({
      TableName: process.env.DYNAMODB_TABLE
    }));

    console.log(`✅ ${result.Items.length} items encontrados`);

    return {
      statusCode: 200,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*'
      },
      body: JSON.stringify({
        success: true,
        count: result.Items.length,
        items: result.Items
      })
    };

  } catch (error) {
    console.error('❌ Erro ao listar items:', error);
    return {
      statusCode: 500,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*'
      },
      body: JSON.stringify({
        success: false,
        message: 'Erro interno do servidor',
        error: error.message
      })
    };
  }
};
