const { DynamoDBClient } = require('@aws-sdk/client-dynamodb');
const { DynamoDBDocumentClient, GetCommand, PutCommand } = require('@aws-sdk/lib-dynamodb');
const { SNSClient, PublishCommand } = require('@aws-sdk/client-sns');

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

const snsConfig = isLocal ? {
  region: 'us-east-1',
  endpoint: 'http://localhost:4566',
  credentials: {
    accessKeyId: 'test',
    secretAccessKey: 'test'
  }
} : { region: 'us-east-1' };

const dynamoClient = new DynamoDBClient(dynamoConfig);
const docClient = DynamoDBDocumentClient.from(dynamoClient);
const snsClient = new SNSClient(snsConfig);

/**
 * UPDATE - Atualizar item existente com notificação SNS
 */
module.exports.handler = async (event) => {
  console.log('✏️  UPDATE Item - Event:', JSON.stringify(event, null, 2));

  try {
    const { id } = event.pathParameters;
    const body = JSON.parse(event.body);

    // Buscar item existente
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

    // Atualizar item
    const updatedItem = {
      ...existing.Item,
      title: body.title !== undefined ? body.title : existing.Item.title,
      description: body.description !== undefined ? body.description : existing.Item.description,
      priority: body.priority !== undefined ? body.priority : existing.Item.priority,
      completed: body.completed !== undefined ? body.completed : existing.Item.completed,
      updatedAt: new Date().toISOString()
    };

    // Salvar no DynamoDB
    await docClient.send(new PutCommand({
      TableName: process.env.DYNAMODB_TABLE,
      Item: updatedItem
    }));

    console.log('✅ Item atualizado:', id);

    // Publicar notificação SNS
    try {
      const snsMessage = {
        action: 'UPDATE',
        item: updatedItem,
        previousItem: existing.Item,
        timestamp: new Date().toISOString()
      };

      await snsClient.send(new PublishCommand({
        TopicArn: process.env.SNS_TOPIC_ARN,
        Message: JSON.stringify(snsMessage),
        Subject: `Item Atualizado: ${updatedItem.title}`
      }));

      console.log('📢 Notificação SNS enviada');
    } catch (snsError) {
      console.error('⚠️  Erro ao enviar notificação SNS:', snsError);
      // Não falhar a operação se SNS falhar
    }

    return {
      statusCode: 200,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*'
      },
      body: JSON.stringify({
        success: true,
        message: 'Item atualizado com sucesso',
        item: updatedItem
      })
    };

  } catch (error) {
    console.error('❌ Erro ao atualizar item:', error);
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
