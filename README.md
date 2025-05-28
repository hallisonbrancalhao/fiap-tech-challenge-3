# Tech Challenge 3 - FIAP

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

- Autenticação de usuários
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
