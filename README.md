<h1 align="center">
<br>Biblioteca em Assembly do Coprocessador Aritmético
</h1>

<h4 align="center">
Projeto desenvolvido para a disciplina de MI - Sistemas Digitais (2025.1) na Universidade Estadual de Feira de Santana.
</h4>

<h2 id="sumario">Sumário</h2>
<ul>
  <li><a href="#equipe"><b>Equipe de Desenvolvimento</b></a></li>
  <li><a href="#problema"><b>Problema</b></a></li>
  <li><a href="#requisitos"><b>Requisitos</b></a></li>
  <li><a href="#recursos"><b>Recursos Utilizados</b></a></li>
  <li><a href="#fundamentacao"><b>Fundamentação Teórica</b></a></li>
  <li><a href="#desenvolvimento"><b>Desenvolvimento</b></a></li>
  <li><a href="#testes"><b>Testes</b></a></li>
  <li><a href="#execucao"><b>Como Executar</b></a></li>
  <li><a href="#conclusao"><b>Conclusão</b></a></li>
  <li><a href="#referencias"><b>Referências</b></a></li>
</ul> 

<h2 id="equipe">Equipe de Desenvolvimento</h2>
<ul>
  <li><a href="https://github.com/Giu-11" target="_blank">Giulia Aguiar Loula</a></li>
  <li><a href="https://github.com/Mizogamii" target="_blank">Sayumi Mizogami Santana</a></li>
  <li><a href="https://github.com/tamillycosta" target="_blank">Tamilly Costa Cerqueira</a></li>
</ul>

<h2 id="problema">Problema: </h2>
<p align="justify">
O projeto tem como objetivo desenvolver uma biblioteca em linguagem Assembly para permitir a utilização, a partir do processador ARM, do coprocessador aritmético desenvolvido no Problema 1. Essa biblioteca facilitará a integração entre software e hardware, possibilitando o uso das operações matriciais aceleradas por hardware em aplicações diversas.
</p>

<h2 id="requisitos">Requisitos</h2>
<ul>
  <li>A biblioteca deve ser implementada em linguagem Assembly compatível com a arquitetura ARM da plataforma DE1-SoC;</li>
  <li>Deve conter as funções necessárias para usar as operações matriciais do coprocessador desenvolvido;</li>
  <li>As funções devem permitir a comunicação entre o processador ARM e a FPGA.</li>
</ul>


<h2 id="recursos">Recursos utilizados: </h2>

- 🧠 Quartus Prime Lite 23.1  
- 🔌 Kit de desenvolvimento DE1-SoC  
- 📝 Visual Studio Code  
- 🌐 Git e GitHub

---
<h2 id="fundamentacao">1. Fundamentação Teórica: </h2>

<div align="justify">
<h3>🛠️ Assembly</h3>
<p>  
Assembly é uma linguagem de programação de baixo nível, sendo uma tentativa de substituir a linguagem de máquina por uma forma mais próxima da linguagem humana, com o objetivo de facilitar o entendimento e a programação. Ela é composta por uma série de instruções compreensíveis pelo programador, os quais são posteriormente convertidas em linguagem de máquina pelo assembler.
</p>
  <p>
  Cada instrução em Assembly corresponde diretamente a uma instrução da arquitetura do processador, o que torna essa linguagem extremamente eficiente e precisa para o controle do hardware. No entanto, essa proximidade com o nível de máquina exige que o programador tenha um conhecimento detalhado da arquitetura utilizada, como os registradores disponíveis, os tipos de instruções e os modos de endereçamento.
</p>
<p>
Assembly é especialmente útil para a otimização de código e a manipulação direta do hardware. Em projetos acadêmicos e profissionais que envolvem FPGAs, microcontroladores ou a construção de processadores, o conhecimento dessa linguagem é de grande importância. 
</p>  
<h3>💾 Registradores</h3>
  <p>
  Os registradores são pequenas unidades de armazenamento de dados integradas diretamente ao processador, responsáveis por guardar temporariamente valores usados nas operações aritméticas e lógicas. Por estarem fisicamente muito próximos da unidade de execução, oferecem altíssima velocidade de acesso, sendo consideravelmente mais rápidos do que qualquer outro tipo de memória. 
  </p>
  <p>
    Enquanto em linguagens de alto nível é possível declarar diversas variáveis armazenadas na memória principal, os registradores são poucos — normalmente somente 32 por CPU. A escassez de registradores exige que o programador ou compilador faça um uso eficiente desses recursos, uma vez que o acesso à memória principal é mais lento. Além disso, o número limitado também está relacionado a princípios de projeto de hardware, como o “menor é mais rápido”, que considera que circuitos menores contribuem para ciclos de clock mais curtos e maior desempenho do processador.
  </p>
  <h3>⚙️ Arquitetura ARM</h3>
  <p>
    ARM (Advanced RISC Machine) é uma família de arquiteturas de processadores baseada no modelo RISC (Reduced Instruction Set Computing), que adota um conjunto de instruções simples e reduzido. Como essas instruções são executadas em poucas etapas, os processadores ARM conseguem realizar tarefas com alta eficiência, baixo consumo de energia e bom desempenho.
  </p>
  <p>
    Apesar da simplicidade das instruções, os processadores ARM oferecem excelente desempenho, o que os torna ideais para uma ampla variedade de aplicações, desde dispositivos móveis e sistemas embarcados até microcontroladores e aplicações industriais. Sua popularidade também se deve à flexibilidade de implementação: a arquitetura pode ser licenciada por fabricantes que a integram a seus próprios projetos, muitas vezes junto a outros elementos como periféricos e unidades de hardware dedicadas.
  </p>
  <h3>🔗 Conexão FPGA-HPS</h3>
  <p>
    A comunicação entre o processador ARM (HPS-Sistema de Processador Rígido) e a FPGA(Arranjo de Portas programáveis em campo) é feita por meio de interfaces dedicadas, como o barramento Lightweight AXI, que permite a troca eficiente de dados entre os dois. Essa conexão funciona com base no conceito de memória compartilhada: cada lado tem acesso direto aos dados da ponte, o que significa que, ao escrever dados de um lado, o outro já pode acessá-los imediatamente. Esse mecanismo é essencial para a integração entre hardware e software na DE1-SoC.
  </p>
</div>

---
<h2 id="desenvolvimento">2. Desenvolvimento: </h2>
<div align="justify">
  <h3>2.1 Mudanças no coprocessador</h3>
  <p>
    No Projeto 1, foi desenvolvido um coprocessador aritmético capaz de realizar cálculos matriciais. A intenção era utilizá-lo também no segundo problema, que consistia na criação de uma biblioteca em Assembly para interface com o coprocessador. No entanto, foram identificadas limitações técnicas na implementação realizada, o que inviabilizou sua utilização na segunda parte do projeto.
  </p>
  <p>
    Dessa forma, para dar continuidade ao desenvolvimento, foi optado a utilização do coprocessador fornecido pelo monitor da disciplina de Sistemas Digitais. O repositório desse coprocessador pode ser acessado <a href="https://github.com/DestinyWolf/CoProcessador_PBL2_SD_2025-1.git">neste link</a>.
</p>
  </p>
  <h3>2.2 Comunicação HPS - FPGA</h3>
   <p>
     Para o desenvolvimento do sistema, foi necessário estabelecer uma interface de comunicação entre o HPS (Hard Processor System) e o FPGA, permitindo o envio de instruções ao coprocessador implementado na lógica programável. Para isso, foi utilizado o Qsys, uma ferramenta da Intel, integrada ao ambiente Quartus Prime, que permite o projeto de sistemas embarcados baseados em FPGA .
   </p>
  <p>
    O Qsys gera automaticamente a lógica de interconexão entre os componentes do sistema, utilizando o barramento Avalon como protocolo padrão de comunicação. 
  </p>
  <p>
    Por meio dessa ferramenta, foi possível configurar os endereços de memória, definir os tipos de acesso e gerar os arquivos de integração entre o HPS e os periféricos implementados no FPGA. O projeto base foi disponibilizado em uma prática de laboratório da disciplina e posteriormente modificado para atender às exigências do sistema proposto.
  </p>
  <p>
    A partir disto, foram adicionadas  as entradas e saídas programadas (PIO) de acordo com os barramentos do coprocessador:
  </p>
<div align="center">

  <table>
    <thead>
      <tr>
        <th>Barramento</th>
        <th>Tipo</th>
        <th>Tamanho</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>Instruction</td>
        <td>Input</td>
        <td>18 bits</td>
      </tr>
      <tr>
        <td>wr</td>
        <td>Input</td>
        <td>1 bit</td>
      </tr>
      <tr>
        <td>Dataout</td>
        <td>Output</td>
        <td>8 bits</td>
      </tr>
      <tr>
        <td>Flags</td>
        <td>Output</td>
        <td>3 bits</td>
      </tr>
    </tbody>
  </table>
</div>

 <!-- tabela
|  Barramento |  Tipo   | Tamanho |
|-------------|---------|---------|
| Instruction | Input   | 18 bits | 
| wr          | Input   | 1 bit   |
| Dataout     | Output  | 8 bits  |
| Flags       | Output  | 3 bits  | 
-->
<p>
  Os barramentos são instanciados no módulo main do coprocessador e linkados com as equivalentes portas do verilog. 
</p>
<h3>2.3 Biblioteca Assembly</h3>
<p>
  No assembly, foram implementadas 7 funções para a estabelecer o envio das instruções e recebimento dos dados.
</p>
<ul>
  <li>Init_hardware:</li>
  <p>
    A função é responsável pela etapa de inicialização do sistema, realizando o mapeamento de memória entre o HPS e o FPGA por meio do AXI Lightweight Bridge.
  </p>
  <p>
    Inicialmente, o arquivo /dev/mem é aberto para permitir o acesso direto à memória física do sistema. Em seguida, é utilizado o mmap() para mapear a região correspondente ao AXI Lightweight Bridge para o espaço de memória virtual do processo, permitindo o acesso direto aos registradores do FPGA via ponteiros.
  </p>
  <p>
    Após o mapeamento, são inicializados os ponteiros que acessam os registradores das interfaces PIO utilizadas na comunicação com o coprocessador: flags, wr, inst e dataOut. Esses ponteiros permitem a escrita e leitura direta dos sinais de controle e dados entre o HPS e o hardware implementado no FPGA.
  </p>
<li>Send_element:</li>
  <p>
    A função tem como objetivo montar e enviar uma instrução do tipo store para o coprocessador. A instrução é codificada em um único inteiro de 32 bits e contém os seguintes campos:
  </p>
  <ul>
    <li>Valor (8 bits): o dado a ser armazenado;</li>
    <li>Linha (i): índice da linha do elemento na matriz;</li>
    <li>Coluna (j): índice da coluna do elemento na matriz;</li>
    <li>Opcode (4 bits): define qual matriz deve receber o dado.</li>
  </ul>
  
  <p>
  Após montar a instrução, a função desativa o sinal de escrita, escreve a instrução no registrador correspondente e aguardar a finalização da operação por meio do sinal de status (*flags);
  </p>
  <li>Execute_operation:</li>
  <p>
    A função é responsável por enviar instruções genéricas ao coprocessador, atuando como um mecanismo auxiliar nas operações principais do sistema. Ela é utilizada para o disparo de comandos de carregamento (load), armazenamento (store) e, principalmente, para o envio de instruções de operações aritméticas sobre matrizes, como adição, subtração e multiplicação.
  </p>
  <li>Mult_escalar:</li>
  <p>
    A função é responsável por montar e enviar uma instrução codificada diretamente ao coprocessador para realizar a operação de multiplicação escalar.
  </p>
  <p>
    Diferente das instruções que operam sobre elementos posicionais (linha, coluna), esta função encapsula o valor escalar diretamente na própria instrução. Isso se deve ao fato de que o opcode destinado à multiplicação escalar já inclui o operando imediato (escalar) dentro de sua codificação, dispensando o uso de registradores auxiliares para envio do dado.
  </p>
  <p>A instrução gerada possui o seguinte formato:</p>
  <ul>
    <li><code>[10:3]</code> – Valor escalar (8 bits);</li>
    <li><code>[2:0]</code> – Opcode da operação (<code>0b101</code>, que representa multiplicação escalar).</li>
  </ul>
  <p>Após montar a instrução, a função a escreve no registrador de instrução monitorado pelo coprocessador e aguarda a conclusão da operação por meio do sinal de status.</p>
  <li>Register_overflow :</li>
  <p>
     A rotina tem como objetivo registrar ocorrências de estouro (overflow) durante operações matriciais no hardware, armazenando a posição (linha e coluna) e o valor que causou o overflow em vetores de acompanhamento. Para garantir a integridade dos buffers, ela só adiciona novas entradas se o contador de overflows (overflow_count) for menor que 25, evitando assim escrita fora dos limites. 
  </p>
  <p>
    O overflow do sistema é sinalizado todas às vezes que uma operação aritmética resulta em um valor fora do range de <code>-128 a 127</code>, quando isto ocorre o coprocessador sinaliza no endereço do ponteiro para flags que o valor operado será truncado e não terá o valor exato da operação.
  </p>
  <li>Result:</li>
<div style="text-align: justify; font-family: Arial, sans-serif; max-width: 800px; margin: auto;">

  <p>
    A função tem como objetivo recuperar, a partir do coprocessador, o valor resultante armazenado na posição <strong>[i][j]</strong> de uma matriz processada. 
    Para isso, a função monta uma instrução codificada com os índices da linha (i) e da coluna (j), além de um <em>opcode</em> específico (<code>0b001</code>), 
    que sinaliza ao hardware que se trata de uma operação de leitura. A instrução é escrita diretamente no registrador responsável por transmitir comandos ao coprocessador.
  </p>

  <h3 style="text-align: center; margin-top: 40px;">Formato da Instrução (9 bits)</h3>

  <div style="display: flex; justify-content: center;">
    <table border="1" cellpadding="10" cellspacing="0" style="border-collapse: collapse; text-align: center;">
      <thead style="background-color: #f2f2f2;">
        <tr>
          <th>Bits</th>
          <th>Campo</th>
          <th>Descrição</th>
          <th>Tamanho (bits)</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>8 : 6</td>
          <td>Índice da linha (i)</td>
          <td>Índice da linha na matriz</td>
          <td>3</td>
        </tr>
        <tr>
          <td>5 : 3</td>
          <td>Índice da coluna (j)</td>
          <td>Índice da coluna na matriz</td>
          <td>3</td>
        </tr>
        <tr>
          <td>2 : 0</td>
          <td>Opcode</td>
          <td>Código da operação (<code>0b001</code> = leitura do resultado)</td>
          <td>3</td>
        </tr>
      </tbody>
    </table>
  </div>

  <p style="text-align: center; margin-top: 10px;"><strong>Opcode <code>0b001</code></strong> indica operação de leitura do resultado.</p>

  <p>
    Após o envio da instrução, a função entra em uma etapa de espera ativa, onde monitora o registrador de status até que o coprocessador sinalize a conclusão da operação, 
    indicando que o dado está disponível no registrador de saída. Em seguida, o valor correspondente à posição solicitada é lido diretamente e armazenado.
  </p>

  <p>
    Antes de retornar esse valor, a função verifica se houve um <em>overflow</em> na operação que gerou o dado. 
    Isso é feito por meio da leitura do valor atual de <code>*flags</code>. 
    Se <code>*flags >= 4</code>, um estouro é identificado, e a função registra a ocorrência chamando <code>register_overflow</code>, 
    armazenando a posição e o valor para análise posterior.
  </p>

  <p>
    Por fim, o valor recuperado é retornado, tornando essa função essencial tanto para a obtenção de resultados como para o controle de falhas numéricas no processamento feito pelo coprocessador.
  </p>
</div>



</div>

---
<h2 id="testes">3. Testes: </h2>

---

<h2 id="execucao">4. Como Executar</h2>

---
<h2 id="conclusao">5. Conclusão:</h2>

---
<h2 id="referencias">6. Referências Bibliográficas</h2>
