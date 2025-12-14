/**
 * SUBSCRIBER SNS - Processar notificações do tópico
 * 
 * Esta função é automaticamente invocada quando uma mensagem
 * é publicada no tópico SNS
 */
module.exports.handler = async (event) => {
  console.log('📬 SNS Subscriber - Event:', JSON.stringify(event, null, 2));

  try {
    // Processar cada registro SNS
    for (const record of event.Records) {
      const snsMessage = JSON.parse(record.Sns.Message);
      
      console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      console.log('📨 NOTIFICAÇÃO SNS RECEBIDA');
      console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      console.log(`🏷️  Assunto: ${record.Sns.Subject}`);
      console.log(`⚡ Ação: ${snsMessage.action}`);
      console.log(`📅 Timestamp: ${snsMessage.timestamp}`);
      console.log('📦 Item:');
      console.log(`   - ID: ${snsMessage.item.id}`);
      console.log(`   - Título: ${snsMessage.item.title}`);
      console.log(`   - Descrição: ${snsMessage.item.description}`);
      console.log(`   - Prioridade: ${snsMessage.item.priority}`);
      console.log(`   - Completo: ${snsMessage.item.completed}`);
      
      if (snsMessage.action === 'UPDATE' && snsMessage.previousItem) {
        console.log('🔄 Mudanças:');
        if (snsMessage.previousItem.title !== snsMessage.item.title) {
          console.log(`   - Título: "${snsMessage.previousItem.title}" → "${snsMessage.item.title}"`);
        }
        if (snsMessage.previousItem.completed !== snsMessage.item.completed) {
          console.log(`   - Status: ${snsMessage.previousItem.completed ? 'Completo' : 'Pendente'} → ${snsMessage.item.completed ? 'Completo' : 'Pendente'}`);
        }
      }
      
      console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      
      // Aqui você pode adicionar lógica adicional como:
      // - Enviar email
      // - Enviar para webhook externo
      // - Salvar log em outro banco
      // - Disparar outras funções Lambda
      // - Etc
    }

    return {
      statusCode: 200,
      body: JSON.stringify({
        success: true,
        message: 'Notificações processadas com sucesso'
      })
    };

  } catch (error) {
    console.error('❌ Erro ao processar notificação SNS:', error);
    return {
      statusCode: 500,
      body: JSON.stringify({
        success: false,
        message: 'Erro ao processar notificação',
        error: error.message
      })
    };
  }
};
