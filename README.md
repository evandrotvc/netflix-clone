# Netflix Clone built using React, Redux Toolkit, Styled Components, Axios

<!-- http://172.27.0.5:3000/ -->
## Instalando projeto

É necessário ter Docker e docker-compose. A aplicação roda o banco e o server tudo em docker. Para instalar o projeto, siga estas etapas:

Setando o .env
```
copie o arquivo .env-example com o nome .env
```
depois rode
```
docker-compose -f docker-compose.local.yml up --build
```

Se tudo foi instalado com sucesso, estará rodando os containers postgres(port: 5432) e o server(port: 3000)

## Use

No terminal, caso queira acessar o container do server, rode
```
docker exec -it survivor-app bash
```

## Tests

No terminal, caso queira rodar os testes, basta rodar o comando anterior e o comando a seguir:
```
rspec
```


<!-- ### Examples
- Create
![alt text](https://github.com/evandrotvc/survivor/blob/main/app/assets/images/create.png)
- UPDATE
![alt text](https://github.com/evandrotvc/survivor/blob/main/app/assets/images/put.png)
- Closest
![alt text](https://github.com/evandrotvc/survivor/blob/main/app/assets/images/closest.png)
- Mark as infected
![alt text](https://github.com/evandrotvc/survivor/blob/main/app/assets/images/infected.png) -->
