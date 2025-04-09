<h1 align="center">
<br>Projeto Coprocessador Aritmético
</h1>

<h4 align="center">
Projeto desenvolvido para a disciplina de MI - Sistemas Digitais (2025.1) na Universidade Estadual de Feira de Santana.
</h4>
<h1 id="sumario" align="center">Sumário</h1>
<ul>
  <li><a href="#equipe"><b>Equipe de Desenvolvimento</b></a></li>
  <li><a href="#problema"><b>Problema</b></a></li>
  <li><a href="#requisitos"><b>Requisitos</b></a></li>
  <li><a href="#recursos"><b>Recursos Utilizados</b></a></li>
  <li><a href="#fundamentacao"><b>Fundamentação Teórica</b></a></li>
  <li><a href="#desenvolvimento"><b>Desenvolvimento</b></a></li>
  <li><a href="#testes"><b>Descrição dos Testes</b></a></li>
  <li><a href="#execucao"><b>Como Executar</b></a></li>
  <li><a href="#conclusao"><b>Conclusão</b></a></li>
  <li><a href="#referencias"><b>Referências</b></a></li>
</ul> 

<h1 id="equipe" align="center">Equipe de Desenvolvimento</h1>
<ul>
  <li><a href="https://github.com/Giu-11" target="_blank">Giulia Aguiar Loula</a></li>
  <li><a href="https://github.com/Mizogamii" target="_blank">Sayumi Mizogami Santana</a></li>
  <li><a href="https://github.com/tamillycosta" target="_blank">Tamilly Costa Cerqueira</a></li>
</ul>


## Problema:
O projeto visa o desenvolvimento de um coprocessador aritmético implementado na FPGA DE1-Soc utilizando a linguagem de descrição de hardware, Verilog.  

---

## Requisitos: 
- O código deve ser escrito em linguagem de descrição de hardware **Verilog**  
- O sistema só poderá utilizar os componentes disponíveis na placa  
- Deve ser capaz de realizar operações com matrizes quadradas de dimensão NxN, com N ≤ 5  
- As seguintes operações devem ser implementadas:
  -  Adição de matrizes  
  -  Subtração de matrizes  
  -  Multiplicação de matrizes  
  -  Multiplicação de matriz por número inteiro  
  -  Determinante  
  -  Transposição de matriz  
  -  Matriz oposta  
- Cada elemento da matriz deve ser representado por um número inteiro de 8 bits  

---

## Recursos utilizados:
- 🧠 Quartus Prime Lite 23.1  
- 🔌 Kit de desenvolvimento DE1-SoC  
- 📝 Visual Studio Code  
- 🌐 Git e GitHub
- ⚙️ Icarus Verilog

---

## 1. Fundamentação Teórica

### 🧮 Coprocessador

<p align="justify">
O coprocessador é um chip especializado projetado para executar operações matemáticas ou lógicas específicas, auxiliando a CPU no processamento de tarefas que exigem alto desempenho. Ao assumir essas funções, o coprocessador reduz a carga de trabalho da CPU, resultando em um aumento de eficiência e desempenho geral do sistema.
</p>

<p align="justify">
Originalmente, todas as operações de um computador eram realizadas exclusivamente pela Unidade Central de Processamento (CPU). Com o avanço da tecnologia e a complexidade crescente das aplicações, surgiram os coprocessadores como solução para distribuir melhor o processamento e otimizar o desempenho computacional.
</p>

<p align="justify">
Existem diversos tipos de coprocessadores, sendo um dos mais conhecidos a GPU (Unidade de Processamento Gráfico). A GPU é responsável por realizar os cálculos necessários para a renderização de imagens 2D e 3D, especialmente em aplicações gráficas e jogos. Ao delegar esses cálculos a uma unidade especializada, a CPU é liberada para executar outras tarefas, contribuindo para um funcionamento mais eficiente do sistema como um todo.
</p>

<p align="justify">
O coprocessador aritmético, por sua vez, é especializado na realização de operações matemáticas complexas, como cálculos de ponto flutuante, funções trigonométricas e outras operações numéricas avançadas. Ao assumir essas tarefas, ele contribui significativamente para o desempenho de aplicações que demandam grande capacidade de cálculo.
</p>

---

### 🚀 Paralelismo

<p align="justify">
O paralelismo é uma técnica essencial para melhorar a eficiência e o desempenho de sistemas computacionais. Em vez de executar cada operação de forma sequencial, ele permite que várias operações sejam realizadas simultaneamente, aproveitando melhor os recursos disponíveis no hardware. Essa abordagem é especialmente útil em aplicações que demandam grande capacidade de processamento, como no caso de operações com matrizes, onde múltiplos cálculos podem ser realizados ao mesmo tempo.
</p>

---

### 🧾 Operações com Matrizes

<p align="justify">
Para realizar operações com matrizes, como adição, subtração e multiplicação, é fundamental que ambas as matrizes envolvidas tenham o mesmo tamanho, ou seja, o mesmo número de linhas e colunas, exceto no caso da multiplicação entre matrizes, que possui uma regra específica.
</p>

#### ➕ Adição de Matrizes

<p align="justify">
A adição de matrizes é feita somando os elementos que ocupam as mesmas posições em cada matriz. O resultado é uma nova matriz, também de mesma dimensão.
</p>

#### ➖ Subtração de Matrizes

<p align="justify">
Na subtração de matrizes, cada elemento da primeira matriz é subtraído pelo elemento correspondente da segunda matriz. O resultado dessa operação também forma uma nova matriz.
</p>

#### ✖️ Multiplicação de Matrizes

<p align="justify">
A multiplicação de matrizes ocorre multiplicando os elementos das linhas da primeira matriz pelos elementos das colunas da segunda, somando os produtos obtidos. Cada soma corresponde a um elemento da matriz resultante, que terá como dimensões o número de linhas da primeira matriz e o número de colunas da segunda. Um detalhe importante da multiplicação de matrizes é que ela precisa que o número de colunas da primeira matriz seja igual ao número de linhas da segunda. E não serem necessariamente realizadas com matrizes de mesmo tamanho.
</p>

#### 🔢 Multiplicação de Matriz por Número Inteiro

<p align="justify">
A multiplicação de uma matriz por um número inteiro é realizada multiplicando esse número por todos os elementos da matriz. O resultado é uma matriz com os mesmos valores, mas escalados.
</p>

#### 🔄 Transposição de Matriz

<p align="justify">
A transposição de uma matriz é obtida a partir da troca ordenada das linhas por colunas. Todos os elementos que estavam em uma linha passam a ocupar a respectiva coluna, e vice-versa.
</p>

#### ➗ Matriz Oposta

<p align="justify">
A matriz oposta pode ser obtida invertendo o sinal de cada elemento da matriz original. Para isso, basta multiplicar todos os elementos por -1.
</p>

---

### 🧮 Determinante

<p align="justify">
O determinante é um número real associado a uma matriz, sendo definido apenas para matrizes quadradas, ou seja, para aquelas que possuem o mesmo número de linhas e colunas, como as de ordem 2x2, 3x3, 4x4 e 5x5.
</p>

<p align="justify">
Existem diferentes métodos para calcular o determinante, como a Regra de Sarrus e o Teorema de Laplace, que variam conforme o tamanho da matriz.
</p>

#### 📐 Determinante 2x2

<p align="justify">
Multiplicam-se os elementos das diagonais principal e secundária, e em seguida subtrai-se o produto da diagonal secundária do produto da diagonal principal.
</p>

#### 📏 Determinante 3x3

<p align="justify">
Utiliza-se a Regra de Sarrus, que consiste em repetir as duas primeiras colunas da matriz ao lado da terceira. Em seguida, somam-se os produtos das diagonais descendentes (da esquerda para a direita) e subtraem-se os produtos das diagonais ascendentes (da direita para a esquerda).
</p>

#### 🧩 Determinante 4x4

<p align="justify">
Aplica-se o Teorema de Laplace: escolhe-se uma linha ou coluna da matriz e, para cada elemento dela, calcula-se o cofator. O cofator é obtido ao eliminar a linha e a coluna desse elemento e calcular o determinante da matriz 3x3 resultante. Depois, multiplica-se cada elemento da linha ou coluna escolhida pelo seu cofator, e a soma desses produtos resulta no determinante da matriz 4x4.
</p>

#### 🧠 Determinante 5x5

<p align="justify">
O cálculo dessa determinante pode ser feito utilizando o Teorema de Laplace, assim como nas matrizes 4x4. O processo envolve mais etapas, mas segue a mesma lógica: primeiro, escolhe-se uma linha ou coluna da matriz. Em seguida, para cada elemento dessa linha ou coluna, calcula-se o seu cofator, o que exige o cálculo de determinantes de matrizes 4x4.
</p>

<p align="justify">
Ou seja, o determinante da matriz 5x5 será a soma dos produtos de cada elemento da linha ou coluna escolhida pelos respectivos cofatores. Como cada cofator envolve um determinante 4x4, esse processo acaba exigindo o cálculo de cinco determinantes 4x4, cada um multiplicado pelo elemento correspondente da linha ou coluna escolhida.
</p>

---

## 2. Desenvolvimento: 
<p align="justify">
Durante a etapa de desenvolvimento, foi necessário realizar um estudo aprofundado sobre o funcionamento e a arquitetura de um coprocessador, bem como sua implementação na placa FPGA DE1-SoC. Isso incluiu o entendimento de conceitos gerais relacionados à estrutura de hardware digital, como o fluxo de dados entre os módulos, a manipulação de informações nos registradores, o acesso à memória da FPGA e o processo completo de entrada, processamento e saída dos dados. Além disso, também foi essencial o aprendizado sobre a manipulação de matrizes, uma vez que as operações realizadas pelo coprocessador envolvem cálculos matriciais, exigindo a organização adequada dos dados e o controle preciso das interações entre os elementos. Esse embasamento teórico foi fundamental para guiar a construção da arquitetura interna e a definição da lógica do sistema, assegurando uma integração funcional e eficiente entre os componentes desenvolvidos.
</p>

### 2.1 Comunicação FPGA:  
<p align="justify">
A primeira etapa do desenvolvimento concentrou-se na definição dos meios de entrada de dados na memória da placa FPGA. Para isso, foi necessário consultar a documentação técnica da Intel, como os manuais da DE1-SoC e os guias de referência do Quartus Prime, a fim de compreender as possibilidades de comunicação com a memória interna. Diversas abordagens foram analisadas, mas o método adotado foi o uso da Embedded Memory do tipo RAM: 1-PORT. Essa escolha se deu principalmente pela facilidade de acesso oferecida pela própria ferramenta Quartus Prime, que disponibiliza suporte à criação de instâncias virtuais dessa memória física por meio do IP Catalog. A RAM: 1-PORT é uma memória síncrona de porta única, que permite operações de leitura e escrita utilizando o mesmo canal, simplificando o controle de acesso aos dados e otimizando a integração com os demais módulos do sistema.
Além disso, o Quartus Prime oferece a ferramenta In-System Memory Content Editor, uma interface gráfica que permite visualizar, em tempo real, o conteúdo armazenado na memória RAM da FPGA. Essa ferramenta possibilita a inspeção dos dados em endereços específicos e a realização de operações de leitura e escrita diretamente pela interface, sem a necessidade de recompilar o projeto. Isso foi fundamental durante os testes e validações, pois facilitou a depuração do comportamento da memória e o acompanhamento do fluxo de dados ao longo da execução das operações matriciais.
</p>

### 2.1 Codificação das Instruções:  
<p align="justify">
Em seguida, foi preciso realizar a codificação das instruções que seriam interpretadas pelo coprocessador. Nesse processo, foram tomadas decisões de projeto importantes, como a definição do formato das instruções, a organização dos bits que representariam a operação desejada e os endereços relacionados à sua execução. Cada instrução foi mapeada com um código binário específico, permitindo que o sistema identificasse de forma clara qual operação deveria ser realizada. Também foi necessário definir como essas instruções seriam armazenadas na memória e em quais posições seriam lidas pelo módulo de controle, garantindo uma execução ordenada e precisa das tarefas.
A memória utilizada suporta uma largura de 256 bits por endereço, o que possibilita o armazenamento sequencial do número máximo de elementos previsto para uma matriz 5x5 com elementos de 8 bits. Isso equivale a 25 elementos × 8 bits = 200 bits, permitindo ainda uma margem para controle ou outros dados auxiliares, se necessário. Sendo assim, a :
</p>
Endereço 000 (Endereço Base):
 Neste endereço são armazenadas as informações de controle da operação. Os primeiros bits 8 contém o opcode, responsável por indicar qual operação deve ser executada (ex.: soma, subtração ou multiplicação). Nos próximos 8 bits, são definidos os tamanhos dos operandos , que informam ao sistema a dimensão das matrizes a serem processadas. Logo após, inicia-se o armazenamento do primeiro operando.
Endereço 001:
Este endereço é reservado para o segundo operando, sendo utilizado apenas em operações que requerem dois operandos, como soma ou multiplicação de matriz
Endereço 010:
Endereço reservado para o resultado da operação

### 2.2 Unidade de Controle:  
<p align="justify">
Na sequência, foi realizada a definição da unidade de controle. Em um processador, essa unidade é responsável por coordenar todo o ciclo de execução das instruções, controlando o fluxo de dados e o funcionamento dos demais módulos. Entre suas principais funções estão: a leitura das instruções na memória, a decodificação dos sinais para identificar a operação a ser realizada, o acionamento dos componentes internos para a execução da tarefa e, por fim, o armazenamento do resultado no local apropriado da memória. Assim, a unidade de controle atua como o "cérebro" do sistema, garantindo que cada etapa seja realizada de forma sincronizada e eficiente. 
Para implementar a unidade de controle, foi preciso utilizar o conceito de máquina de estados finitos (MEF), uma vez que esse é o modelo fundamental para organizar o comportamento sequencial de um processador. A máquina de estados implementada segue o modelo de Moore, no qual as saídas dependem exclusivamente do estado atual, garantindo maior previsibilidade e estabilidade no controle do sistema. No total, foram definidos sete estados distintos, responsáveis por conduzir cada etapa do ciclo de instrução: leitura, decodificação, execução da operação e escrita dos resultados na memória.
</p>

### 2.3 Módulo de Execução:  
<p align="justify">
O módulo de execução é responsável por selecionar e encaminhar corretamente os operandos para a ULA (Unidade Lógica e Aritmética), com base no opcode da operação fornecida pela unidade de controle. Esse módulo atua como elo entre a decodificação da instrução e a execução propriamente dita, garantindo que os dados corretos sejam processados de acordo com a lógica definida.
As operações foram codificadas segundo a seguinte estrutura:
</p>

| Operação                  | Código Binário |
|---------------------------|----------------|
| Soma de Matrizes          | `000`          |
| Subtração de Matrizes     | `001`          |
| Multiplicação de Matrizes | `010`          |
| Multiplicação por Escalar | `011`          |
| Transposição              | `100`          |
| Inversão (Matriz Oposta)  | `101`          |
| Determinante              | `110`          |

### Cada operação:
<p align="justify">
A seleção de cada elemento da matriz é feita utilizando a notação [(i*8) +: 8], que acessa 8 bits a partir da posição i*8 dentro do vetor. Essa abordagem facilita a manipulação dos dados em Verilog, permitindo trabalhar com cada elemento individualmente em operações como soma, subtração e outras.
</p>

#### Adição de matrizes:
<p align="justify">
  Na operação de adição, um loop for percorre os 25 elementos de ambas as matrizes. Em cada iteração, os elementos correspondentes (na mesma posição) são acessados pelo mesmo índice, somados entre si, e o resultado é armazenado em uma terceira matriz, chamada de matriz resultado
</p>

#### Subtração de matrizes: 
<p align="justify">
Na operação de subtração, foi utilizada a mesma lógica da adição: o loop for percorre os elementos de ambas as matrizes, acessando os dados correspondentes em cada posição. Em seguida, os valores são subtraídos e o resultado é armazenado na matriz resultado.
</p>

#### Multiplicação de matrizes:
<p align="justify">
Antes que os dados possam ser operados, para a multiplicação, a matriz é reescrita. Já que, da forma como ela é recebida, um registrador de 200 bits, pode ser difícil para desenvolver a lógica para percorrê-la e acessar os valores corretos, por isso os dados são transferidos para um array bidimensional de registradores de 8 bits, facilitando o desenvolvimento.
Assim, as matrizes são percorridas de forma que sejam multiplicados os valores da linha da primeira matriz com os das colunas da segunda matriz e somando, para encontrar a matriz resultante. Contudo, foi necessária uma mudança na forma de multiplicar os números, já que há uma limitação na quantidade de multiplicações que o hardware consegue realizar ao mesmo tempo, a sua quantidade de DSP blocks.
Dessa forma, com intuito de diminuir o uso desse recurso, não foi utilizado o operador de multiplicação nativo do Verilog, em vez disso, a multiplicação entre dois números foi feita utilizando deslocamento de bits. Na lógica usada para a multiplicação de dois números, para cada dígito igual a 1 do primeiro operando, deve se repetir o segundo operando deslocando ele uma quantidade de bits para a esquerda igual à quantidade de bits à direita do dígito 1 do primeiro operando. Depois, todos esses valores devem ser somados, o que resultando no produto entre os dois números.
Contudo, essa logica não obtém as respostas corretas caso sejam usados números negativos. Por isso, antes de multiplicar, o sinal de números negativos é trocado, sendo guardado se o resultado deve ser negativo, baseado na quantidade de operandos negativos, possibilitando que o resultado tenha o modulo correto. Após isso, caso o resultado deva ser negativo, o sinal é adicionado nele.
</p>

#### Determinante:
<p align="justify">
Assim como a multiplicação de matrizes, a determinante possui uma lógica mais complexa para quais valores acessar na matriz. Por isso, os dados da matriz são reescritos em um array bidimensional de 8 bits, conforme o tamanho da matriz que será operada com, facilitando o entendimento e escrita do código.
Para o cálculo de determinantes, foi necessário o uso de uma lógica diferente para cada um dos possíveis tamanho de matriz, 2x2, 3x3, 4x4 e 5x5, já que não há um método que possa ser usado em todos os casos. Caso a matriz seja de dimensões 2x2, o cálculo da determinante é feita subtraindo a multiplicação dos elementos da diagonal secundaria dos elementos da diagonal principal, já para a matriz 3x3 é usado a regra de Sarrus e as 4x4 e 5x5 o teorema de Laplace. Contudo, para o cálculo da determinante de matrizes 4x4 e 5x5, por necessitar de uma grande quantidade de multiplicações, foi necessário que a operação fosse dividida e não executada simultaneamente.
Assim, a operação deve ocorrer em mais de um ciclo de clock, padronizadamente, permitindo que os DSP blocks, e o circuito na totalidade, seja reutilizado. Seguindo o teorema de Laplace, a cada ciclo, um valor da primeira linha é escolhido, seguindo a posição deles na linha. Depois é criada uma matriz menor, com os números que não estão na mesma linha ou coluna desse numero, em seguida calculando a determinante dessa matriz e multiplicando pelo número anteriormente escolhido. Após esse processo seja repetido para todos os números na primeira linha, os valores são somados e subtraídos na ordem devida conforme o teorema, resultando na determinante da matriz.
Aplicando essa lógica, o cálculo da determinante de matrizes de tamanho 4x4 é feito em 4 ciclos de clock, e as de tamanho 5x5 em 5 ciclos. Isso ocorre, já que diferente do oque é feito para a determinante de 4x4, dentro do cálculo para as 5x5, a determinante 4x4 é calculada em somente um ciclo. Isso é feito para não haver uma grande diferença da duração da conta entre elas, oque ocorreria caso a 4x4 fosse calculada em 1 ciclo e a 5x5 em 5 ciclos, vezes os 4 que durariam para cada uma de suas etapas no teorema de Laplace, totalizando 20 ciclos.
</p>

#### Transposição de matriz:
<p align="justify">
Para a transposição de matriz, o registrador de entrada é percorrido para acessar os valores corretos de acordo com qual seria o número na posição linha e coluna caso fosse uma matriz. Após isso, esses dados são reescritos outro registrador, com sua linha e coluna trocadas uma pela outra.
</p>

#### Multiplicação de matriz por número inteiro:
<p align="justify">
Para a multiplicação da matriz por um número inteiro, utilizou-se um loop que percorre todos os elementos da matriz original, realizando a multiplicação de cada valor pelo escalar informado. O resultado de cada operação é armazenado em uma nova matriz, representando o resultado da multiplicação escalar.
</p>

#### Matriz oposta:
<p align="justify">
Para a operação de matriz oposta, todos os 25 elementos da matriz foram percorridos, por meio da estrutura de repetição for, e cada valor foi negado individualmente após a conversão para signed, garantindo a correta interpretação dos dados com sinal. 
</p>

### Tratamento para overflow:
<p align="justify">
Em todas as operações, com exceção da transposição de matriz, há a possibilidade que o resultado obtido seja maior do que pode ser armazenado em 8 bits, ou seja, um overflow. Para evitar que isso resulte em respostas inesperadas para as operações, todos resultados são guardados como registradores com mais bits e depois é testado se eles excedem o limite para 8 bits com complemento a 2, ou seja, maiores que 127 ou menores que −128. Caso o resultado passe desses limites, ele é igualado ao limite que ele excedeu, para mais ou para menos.
</p>

---
