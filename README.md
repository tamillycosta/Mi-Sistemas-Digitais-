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

## 📋 Requisitos: 
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

## 💻 Recursos utilizados:
- 🧠 Quartus Prime Lite 23.1  
- 🔌 Kit de desenvolvimento DE1-SoC  
- 📝 Visual Studio Code  
- 🌐 Git e GitHub
- ⚙️ Icarus Verilog

---

## 📚 1. Fundamentação Teórica

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

## 🏗️ 2. Desenvolvimento: 
(…)  

### 🔗 2.1 Comunicação FPGA:  
(…)  

### 💾 2.1 Codificação das Instruções:  
(…)  

### 🧠 2.2 Unidade de Controle:  
(…)  

### ⚙️ 2.3 Módulo de Execução:  
(…)

---

> ✅ Continua na próxima seção com **Descrição de Teste**, **Como Executar**, **Conclusão**, **Referências**, etc.
