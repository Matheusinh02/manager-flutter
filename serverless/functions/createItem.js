const { DynamoDBClient } = require('@aws-sdk/client-dynamodb');
const { DynamoDBDocumentClient, PutCommand } = require('@aws-sdk/lib-dynamodb');
const { SNSClient, PublishCommand } = require('@aws-sdk/client-sns');
const { v4: uuidv4 } = require('uuid');

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
 * CREATE - Criar novo item com notificação SNS
 */
module.exports.handler = async (event) => {
  console.log('📝 CREATE Item - Event:', JSON.stringify(event, null, 2));

  try {
    const body = JSON.parse(event.body);
    
    // Validação
    if (!body.title || !body.description) {
      return {
        statusCode: 400,
        headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*'
        },
        body: JSON.stringify({
          success: false,
          message: 'Campos obrigatórios: title, description'
        })
      };
    }

    // Criar item
    const item = {
      id: uuidv4(),
      title: body.title,
      description: body.description,
      priority: body.priority || 'medium',
      completed: body.completed || false,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    };

    // Salvar no DynamoDB
    await docClient.send(new PutCommand({
      TableName: process.env.DYNAMODB_TABLE,
      Item: item
    }));

    console.log('✅ Item criado:', item.id);

    // Publicar notificação SNS
    try {
      const snsMessage = {
        action: 'CREATE',
        item: item,
        timestamp: new Date().toISOString()
      };

      await snsClient.send(new PublishCommand({
        TopicArn: process.env.SNS_TOPIC_ARN,
        Message: JSON.stringify(snsMessage),
        Subject: `Novo Item Criado: ${item.title}`
      }));

      console.log('📢 Notificação SNS enviada');
    } catch (snsError) {
      console.error('⚠️  Erro ao enviar notificação SNS:', snsError);
      // Não falhar a operação se SNS falhar
    }

    return {
      statusCode: 201,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*'
      },
      body: JSON.stringify({
        success: true,
        message: 'Item criado com sucesso',
        item: item
      })
    };

  } catch (error) {
    console.error('❌ Erro ao criar item:', error);
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
