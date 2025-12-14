const { DynamoDBClient } = require('@aws-sdk/client-dynamodb');
const { DynamoDBDocumentClient, GetCommand, DeleteCommand } = require('@aws-sdk/lib-dynamodb');

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
 * DELETE - Remover item
 */
module.exports.handler = async (event) => {
  console.log('🗑️  DELETE Item - Event:', JSON.stringify(event, null, 2));

  try {
    const { id } = event.pathParameters;

    // Verificar se item existe
    const existing = await docClient.send(new GetCommand({
      TableName: process.env.DYNAMODB_TABLE,
      Key: { id }
    }));

    if (!existing.Item) {
      return {
        statusCode: 404,
        headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*'
        },
        body: JSON.stringify({
          success: false,
          message: 'Item não encontrado'
        })
      };
    }

    // Deletar item
    await docClient.send(new DeleteCommand({
      TableName: process.env.DYNAMODB_TABLE,
      Key: { id }
    }));

    console.log('✅ Item deletado:', id);

    return {
      statusCode: 200,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*'
      },
      body: JSON.stringify({
        success: true,
        message: 'Item deletado com sucesso',
        deletedItem: existing.Item
      })
    };

  } catch (error) {
    console.error('❌ Erro ao deletar item:', error);
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
