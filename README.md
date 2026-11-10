# Recurso FiveM de Edição de Handling de Veículos

Garagem de Ajustes é um recurso FiveM com editor de handling de veículos dentro do jogo. Ele lista os modelos de veículos disponíveis no registro do jogo, permite ajustar propriedades de handling com pré-visualização no veículo em que o jogador está sentado e salva as alterações para sincronizá-las com todos os jogadores.

## Install

1. Coloque a pasta do recurso no diretório `resources` do servidor.
2. Adicione `ensure handling_editor` ao `server.cfg`, usando o nome da pasta do recurso.
3. Conceda a permissão ACE para os jogadores autorizados, por exemplo: `add_ace group.admin handlingeditor.use allow`.
4. Inicie ou reinicie o servidor. As alterações salvas ficam no arquivo `handling_overrides.json` dentro da pasta do recurso.

## Use

1. Entre no servidor com uma conta que tenha a permissão ACE configurada.
2. Use o comando `/handling` para abrir o editor.
3. Pesquise e selecione um modelo de veículo na lista.
4. Ajuste os controles deslizantes. As alterações são pré-visualizadas no veículo em que você está sentado e salvas automaticamente após uma breve pausa.
5. Use “Reset override” para remover as alterações salvas para o modelo selecionado.

---

More FiveM resource projects by EnderDevelopment: https://github.com/EnderDevelopment

Project page: https://dash.enderdevelopment.com/community/61be6545-dc58-49ef-baea-4bcd3ba0c6e1?utm_source=github&utm_medium=readme&utm_campaign=auto_publish&utm_content=61be6545-dc58-49ef-baea-4bcd3ba0c6e1
