# Tech Challenge 3 e 4 - FIAP

Aplicativo de gerenciamento financeiro desenvolvido para o Tech Challenge 3 da FIAP.

## Vídeo demonstrativo
O vídeo demonstrativo se encontra no link: https://www.youtube.com/watch?v=K68NQv2fqoU

## Requisitos

- Flutter SDK (versão 3.19.0 ou superior)
- Dart SDK (versão 3.3.0 ou superior)
- Android Studio / VS Code
- Git
- Android SDK (para desenvolvimento Android)
- Um dispositivo Android ou emulador configurado

## Configuração do Ambiente

1. Instale o Flutter SDK seguindo a [documentação oficial](https://flutter.dev/docs/get-started/install)
2. Configure as variáveis de ambiente:
   - Adicione o Flutter ao PATH do sistema
   - Configure o ANDROID_HOME para o Android SDK

3. Verifique se o Flutter está configurado corretamente executando:
```bash
flutter doctor
```
Resolva qualquer problema indicado pelo comando acima.

## Configuração do Firebase

Este projeto já está configurado com o Firebase. Para executá-lo, você precisa apenas:

1. Criar o diretório `android/app/` se ele não existir
2. Criar um arquivo chamado `google-services.json` dentro do diretório `android/app/` com o seguinte conteúdo:
   ```json
   {
     "project_info": {
       "project_number": "858480286980",
       "project_id": "tech-challenge-3-34817",
       "storage_bucket": "tech-challenge-3-34817.firebasestorage.app"
     },
     "client": [
       {
         "client_info": {
           "mobilesdk_app_id": "1:858480286980:android:0d9c293523469755a48451",
           "android_client_info": {
             "package_name": "com.example.tech_challenge_3"
           }
         },
         "oauth_client": [],
         "api_key": [
           {
             "current_key": "AIzaSyD5TZoDTE3mkmKgFw2cXN9kIZC_-QwX08Q"
           }
         ],
         "services": {
           "appinvite_service": {
             "other_platform_oauth_client": []
           }
         }
       }
     ],
     "configuration_version": "1"
   }
   ```

## Executando o Projeto

1. Clone o repositório:
```bash
git clone [URL_DO_REPOSITÓRIO]
cd tech-challenge-3
```

2. Instale as dependências:
```bash
flutter pub get
```

3. Conecte um dispositivo Android ou inicie um emulador

4. Execute o projeto:
```bash
flutter run
```

Se você estiver usando o VS Code ou Android Studio, pode executar o projeto através da interface gráfica:
- VS Code: Pressione F5 ou clique no botão "Run and Debug"
- Android Studio: Clique no botão "Run" (ícone de play)

## Estrutura do Projeto

```
lib/
├── common/           # Widgets e blocos comuns
├── core/            # Configurações e utilitários
├── data/            # Camada de dados (repositories e models)
├── domain/          # Regras de negócio (entities e usecases)
└── presentation/    # Interface do usuário (pages e widgets)
```

## Funcionalidades

- Autenticação de usuários com duplo fator (PIN)
- Gerenciamento de transações financeiras
- Visualização de extrato
- Gráficos de gastos
- Upload de comprovantes
- Categorização de transações

## Dependências Principais

- `flutter_bloc`: Gerenciamento de estado
- `firebase_core`: Integração com Firebase
- `firebase_auth`: Autenticação
- `cloud_firestore`: Banco de dados
- `firebase_storage`: Armazenamento de arquivos
- `fl_chart`: Gráficos
- `intl`: Formatação de datas e valores
- `image_picker`: Seleção de imagens
- `flutter_svg`: Suporte a SVG
- `shared_preferences`: Armazenamento local seguro
- `dartz`: Programação funcional para tratamento de erros

## Segurança e Autenticação

### Implementação Atual

O aplicativo implementa um sistema de autenticação de dois fatores utilizando PIN como segundo fator de segurança. A arquitetura de segurança foi desenvolvida seguindo os princípios da Clean Architecture, garantindo separação de responsabilidades e facilitando testes e manutenção.

### Demonstração da autenticação de dois fatores utilizando PIN:

![pin_demonstration_gif](https://github.com/user-attachments/assets/2a0e27e4-8b8e-4db3-9cb3-b4da65bc34d0)

#### Características de Segurança Implementadas:

- **Duplo Fator**: Autenticação por email/senha + PIN de 4 dígitos
- **Validação Robusta**: Verificação de formato e comprimento do PIN
- **Limite de Tentativas**: Máximo de 3 tentativas incorretas
- **Armazenamento Seguro**: PIN criptografado localmente via SharedPreferences
- **Tratamento de Erros**: Sistema funcional com Either para resultados seguros

#### Fluxo de Autenticação:

1. **Login**: Email e senha via Firebase Auth
2. **Segundo Fator**: Validação do PIN de 4 dígitos
3. **Acesso**: Navegação para área restrita após validação

### Configurações de Desenvolvimento

**Observação**: As configurações atuais são para fins de desenvolvimento e demonstração:

- **PIN Padrão**: `5678` (hardcoded para simulação)
- **Código de Recuperação**: `1234` (simulação de email)
- **Armazenamento**: SharedPreferences local (para demonstração)

### Recomendações para Produção

Para um ambiente de produção, recomendamos as seguintes melhorias de segurança:

#### 1. Autenticação de Dois Fatores Profissional
```dart
- Google Sign-In com 2FA
- Apple ID com autenticação biométrica
- SMS/Email com códigos temporários
- Authenticator apps (Google Authenticator, Authy)
```

#### 2. Armazenamento Seguro de PIN
```dart
- Flutter Secure Storage (criptografia AES)
- Biometric Storage (fingerprint/face ID)
- Hardware Security Module (HSM)
- Keychain (iOS) / Keystore (Android)
```

#### 3. Criptografia Avançada
```dart
- Hash do PIN com salt único por usuário
- Criptografia AES-256 para dados sensíveis
- Certificados SSL/TLS para comunicação
- Validação de integridade de dados
```

#### 4. Auditoria e Monitoramento
```dart
- Logs de tentativas de acesso
- Alertas de atividades suspeitas
- Rate limiting para tentativas de login
- Geolocalização para detecção de fraudes
```

### Considerações de Segurança
- **Separação de Camadas**: Lógica de segurança isolada no domain
- **Inversão de Dependência**: Interface de repositório permite troca de implementação
- **Tratamento Funcional**: Either para resultados seguros e previsíveis
- **Testabilidade**: Cada camada pode ser testada independentemente

## Troubleshooting

1. Erro de compilação Android:
   - Verifique se o `google-services.json` está no local correto (`android/app/google-services.json`)
   - Execute `flutter clean` e `flutter pub get`
   - Verifique se o Android SDK está instalado e configurado corretamente

2. Erro de autenticação:
   - Verifique se o dispositivo/emulador tem conexão com a internet
   - Verifique se o arquivo `google-services.json` está correto

3. Erro de permissão:
   - Verifique se o aplicativo tem permissão para acessar a internet
   - Verifique se o dispositivo/emulador tem permissão para acessar a câmera (para upload de comprovantes)

## Contribuição

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/nova-feature`)
3. Commit suas mudanças (`git commit -m 'Adiciona nova feature'`)
4. Push para a branch (`git push origin feature/nova-feature`)
5. Abra um Pull Request

## Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.
