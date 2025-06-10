<h1 align="center">
<br>Filtro Detector de Borda
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
Desenvolver um programa em linguagem C que aplique filtros de detecção de bordas em uma imagem digital, utilizando a biblioteca em Assembly previamente desenvolvida em conjunto com o coprocessador de operações matriciais implementado na FPGA. O sistema deve ser capaz de realizar o pré-processamento da imagem (conversão para escala de cinza) e aplicar diferentes operadores de detecção de bordas (Sobel, Prewitt, Roberts e Laplaciano). A solução deverá operar com imagens de 320x240 pixels, processadas com 8 bits por pixel.
</p>

---
<h2 id="requisitos">Requisitos</h2>
<p align="justify">
<ul>
  <li>O código deverá ser desenvolvido em linguagem de programação C;</li>
  <li>A aplicação deverá realizar a leitura de uma imagem com resolução de 320x240 pixels;</li>
  <li>A imagem deverá ser convertida para escala de cinza, utilizando representação de 8 bits por pixel;</li>
  <li>Após o pré-processamento, o programa deverá aplicar os seguintes filtros de detecção de borda:
    <ul>
      <li>Sobel (máscara 3x3);</li>
      <li>Sobel expandido (máscara 5x5);</li>
      <li>Prewitt (máscara 3x3);</li>
      <li>Roberts (máscara 2x2);</li>
      <li>Laplaciano (máscara 5x5).</li>
    </ul>
</li>
  </li>
  
</ul>
</p>

---
<h2 id="recursos">Recursos utilizados: </h2>

- 🧠 Quartus Prime Lite 23.1  
- 🔌 Kit de desenvolvimento DE1-SoC  
- 📝 Visual Studio Code  
- 🌐 Git e GitHub

---
<h2 id="fundamentacao">1. Fundamentação Teórica: </h2>
<div align="justify">
  <h3>Detectores de bordas</h3>  
    <p>Detectores de bordas são ferramentas de processamento de imagem locais utilizadas para identificar pixels que representam bordas, ou seja, regiões onde ocorrem mudanças abruptas de intensidade na imagem. A detecção de bordas baseia-se em propriedades de derivadas, principalmente de primeira e segunda ordem.</p>
    <p>A derivada de primeira ordem é eficaz na detecção de variações graduais na intensidade da imagem, geralmente resultando em bordas mais espessas. Já a derivada de segunda ordem é mais sensível a mudanças abruptas, sendo utilizada para realçar detalhes finos, como linhas delgadas, pontos isolados e até mesmo ruídos.</p>
<p>Além disso, o sinal da segunda derivada pode fornecer informações sobre a direção da transição de intensidade (de claro para escuro ou de escuro para claro), o que pode ser explorado para uma detecção mais precisa das bordas.</p>
  
  <h3>Convolução</h3>
    <p>A convolução é uma operação matemática que consiste no somatório do produto entre duas funções ao longo do deslocamento entre elas. No processamento de imagens, essa operação é realizada entre a matriz da imagem e uma matriz menor chamada de máscara ou kernel, que atua como um filtro. O objetivo da convolução é extrair informações relevantes da imagem, como bordas, texturas e contrastes, ou aplicar efeitos como suavização e remoção de ruídos.</p>
    <p>Para aplicar a convolução, a máscara vai se deslocando sobre a imagem, multiplicando seus valores pelos valores dos pixels correspondentes. Depois disso, os resultados são somados, gerando um valor que compõe um pixel da imagem de saída. Esse processo é repetido para todas as posições válidas da imagem, formando assim uma nova matriz com as características realçadas.
Durante esse deslocamento, utiliza-se o stride, que define quantos pixels a máscara avança a cada passo. Já o padding é usado para adicionar uma borda artificial em volta da imagem original, evitando que informações das extremidades sejam perdidas durante a aplicação da convolução.</p>
    <p>A partir desses princípios, foram desenvolvidos diversos filtros para o realce de bordas nas imagens. Os mais conhecidos são os filtros de Sobel, Prewitt, Roberts e Laplaciano. Cada um desses filtros possui sua própria matriz, que destaca as mudanças de intensidade em direções específicas.</p>

  <h3>Sobel</h3>
  <p>O filtro de Sobel é utilizado para a detecção de bordas em imagens digitais, fornecendo tanto a direção (horizontal ou vertical) quanto a taxa de variação da intensidade luminosa nessa direção. Ele funciona por meio da aproximação do gradiente da imagem, utilizando derivadas de primeira ordem.
Para isso, o filtro aplica a convolução da imagem com duas máscaras convolucionais 3x3: uma para detectar variações na direção horizontal (Gx) e outra na direção vertical (Gy). As máscaras utilizadas são:</p>

<div align="center" style="margin: 20px 0;">

| Gx (máscara horizontal) | Gy (máscara vertical) |
|-------------------------|-----------------------|
| <img src="imagensReadMe/sobel3x3Gx.png" style="width: 190px; height: 140px; object-fit: contain; display: block; margin: 0 auto;"> | <img src="imagensReadMe/sobel3x3Gy.png" style="width: 190px; height: 140px; object-fit: contain; display: block; margin: 0 auto;"> |

</div>

<p>As convoluções da imagem com essas máscaras resultam em duas imagens intermediárias: Gx (variação horizontal) e Gy (variação vertical). A partir delas, calcula-se a magnitude do gradiente, que representa a intensidade da borda no ponto analisado.</p>
Para o cálculo do gradiente é utilizada a fórmula:

$$
G = \sqrt{G_x^2 + G_y^2}
$$

Onde:
- $G_x$ = componente horizontal do gradiente
- $G_y$ = componente vertical do gradiente

<p>Após a aplicação ele resulta uma nova imagem com bordas mais destacadas, que auxiliam na análise visual e na interpretação de dados.</p>
<p>Existe também uma variação do Sobel utilizando máscaras 5×5, que oferece maior precisão na detecção de bordas e uma suavização mais pronunciada, sendo especialmente útil em imagens de alta resolução, onde maior precisão e suavização são desejadas. Segue abaixo as máscaras do sobel 5x5: </p>

<div align="center" style="margin: 20px 0;">

| Gx (máscara horizontal) | Gy (máscara vertical) |
|-------------------------|-----------------------|
| <img src="imagensReadMe/sobel5x5Gx.png" style="width: 190px; height: 140px; object-fit: contain; display: block; margin: 0 auto;"> | <img src="imagensReadMe/sobel5x5Gy.png" style="width: 190px; height: 140px; object-fit: contain; display: block; margin: 0 auto;"> |

</div>

<p>Essas máscaras ampliadas são indicadas quando se deseja um balanceamento melhor entre detalhamento da borda e redução de ruído.</p>

<h3>Prewitt</h3>
<p>Assim como o filtro de Sobel, o filtro de Prewitt também utiliza máscaras nas direções horizontal e vertical para detecção de bordas. No entanto, ele é mais adequado para imagens simples e com pouco ruído, pois não oferece tanta precisão na detecção de bordas. Por ser computacionalmente mais simples, o filtro de Prewitt tende a ser mais rápido que outros filtros mais sofisticados. As máscaras utilizadas são: </p>
<div align="center" style="margin: 20px 0;">

| Gx (máscara horizontal) | Gy (máscara vertical) |
|-------------------------|-----------------------|
| <img src="imagensReadMe/prewittGx.png" style="width: 190px; height: 140px; object-fit: contain; display: block; margin: 0 auto;"> | <img src="imagensReadMe/prewittGy.png" style="width: 190px; height: 140px; object-fit: contain; display: block; margin: 0 auto;"> |

</div>

<h3>Roberts</h3>
<p>O filtro de Roberts é um operador de detecção de bordas baseado no cálculo de gradientes diagonais. Ele utiliza máscaras convolucionais 2×2, o que o torna extremamente leve e eficiente em termos computacionais. No entanto, essa simplicidade o torna mais sensível a ruídos e menos preciso na detecção de bordas suaves.
</p>
<p>A detecção é feita aplicando duas máscaras, que estimam o gradiente nas diagonais principais da imagem. A magnitude do gradiente é calculada com a mesma fórmula utilizada nos demais operadores.
</p>
<p>As máscaras utilizadas são: </p>
<div align="center" style="margin: 20px 0;">

| Diagonal principal | Diagonal secundária |
|-------------------------|-----------------------|
| <img src="imagensReadMe/robertsGx.png" style="width: 190px; height: 140px; object-fit: contain; display: block; margin: 0 auto;"> | <img src="imagensReadMe/robertsGy.png" style="width: 190px; height: 140px; object-fit: contain; display: block; margin: 0 auto;"> |

</div>

<h3>Laplaciano</h3>
<p>O filtro laplaciano é utilizada para a destacar áreas de mudança rápida de intensidade, que geralmente estão associadas às bordas de uma imagem. Diferentemente dos outros filtros como sobel, roberts e prewitt, o filtro laplaciano utiliza a segunda derivada da intensidade da imagem.</p>
<p>A segunda derivada da intensidade da imagem é representada por: </p>

$$
\nabla^2 I(x, y) = \frac{\partial^2 I}{\partial x^2} + \frac{\partial^2 I}{\partial y^2}
$$

Onde:
- $\nabla^2 I(x, y)$ é o Laplaciano da imagem.
- $\frac{\partial^2 I}{\partial x^2}$ é a segunda derivada na direção $x$.
- $\frac{\partial^2 I}{\partial y^2}$ é a segunda derivada na direção $y$.

<p>Embora o filtro laplaciano seja sensível a mudanças de intensidade em todas as direções, ele também é altamente sensível ao ruído, o que pode limitar sua aplicação direta em imagens reais.</p>

<p>A máscara utilizada foi: </p>
<div align="center" style="margin: 20px 0;">
  <img src="imagensReadMe/laplaciano.png" style="width: 190px; height: 140px; object-fit: contain; display: block; margin: 0 auto;">
</div>

</div>
---
<h2 id="desenvolvimento">2. Desenvolvimento: </h2>

---
<h2 id="testes">3. Testes: </h2>

<p>
  As imagens utilizadas para os testes foram: 
</p>

<div align="center" style="margin: 20px 0;">
<table>
  <tr>
    <td>
      <img src="imagensReadMe/in/1.png"; object-fit: contain; display: block; margin: 0 auto;">
    </td>
    <td>
      <img src="imagensReadMe/in/2.png"; object-fit: contain; display: block; margin: 0 auto;">
    </td>
    <td>
      <img src="imagensReadMe/in/3.png"; object-fit: contain; display: block; margin: 0 auto;">
    </td>
    <td>
      <img src="imagensReadMe/in/4.png"; object-fit: contain; display: block; margin: 0 auto;">
    </td>
  </tr>
</table>
</div>

<h3>Sobel 3x3</h3>
<div align="center" style="margin: 20px 0;">
<table>
  <tr>
    <td>
      <img src="imagensReadMe/out/1sobel3x3.png" ; object-fit: contain; display: block; margin: 0 auto;">
    </td>
    <td>
      <img src="imagensReadMe/out/2sobel3x3.png"; object-fit: contain; display: block; margin: 0 auto;">
    </td>
    <td>
      <img src="imagensReadMe/out/3sobel3x3.png"; object-fit: contain; display: block; margin: 0 auto;">
    </td>
    <td>
      <img src="imagensReadMe/out/4sobel3x3.png"; object-fit: contain; display: block; margin: 0 auto;">
    </td>
  </tr>
</table>
</div>

<h3>Sobel 5x5</h3>
<div align="center" style="margin: 20px 0;">
<table>
  <tr>
    <td>
      <img src="imagensReadMe/out/1sobel5x5.png" ; object-fit: contain; display: block; margin: 0 auto;">
    </td>
    <td>
      <img src="imagensReadMe/out/2sobel5x5.png"; object-fit: contain; display: block; margin: 0 auto;">
    </td>
    <td>
      <img src="imagensReadMe/out/3sobel5x5.png"; object-fit: contain; display: block; margin: 0 auto;">
    </td>
    <td>
      <img src="imagensReadMe/out/4sobel5x5.png"; object-fit: contain; display: block; margin: 0 auto;">
    </td>
  </tr>
</table>
</div>

<h3>Prewitt</h3>
<div align="center" style="margin: 20px 0;">
<table>
  <tr>
    <td>
      <img src="imagensReadMe/out/1prewitt.png" ; object-fit: contain; display: block; margin: 0 auto;">
    </td>
    <td>
      <img src="imagensReadMe/out/2prewitt.png"; object-fit: contain; display: block; margin: 0 auto;">
    </td>
    <td>
      <img src="imagensReadMe/out/3prewitt.png"; object-fit: contain; display: block; margin: 0 auto;">
    </td>
    <td>
      <img src="imagensReadMe/out/4prewitt.png"; object-fit: contain; display: block; margin: 0 auto;">
    </td>
  </tr>
</table>
</div>

<h3>Roberts</h3>
<div align="center" style="margin: 20px 0;">
<table>
  <tr>
    <td>
      <img src="imagensReadMe/out/1roberts.png" ; object-fit: contain; display: block; margin: 0 auto;">
    </td>
    <td>
      <img src="imagensReadMe/out/2roberts.png"; object-fit: contain; display: block; margin: 0 auto;">
    </td>
    <td>
      <img src="imagensReadMe/out/3roberts.png"; object-fit: contain; display: block; margin: 0 auto;">
    </td>
    <td>
      <img src="imagensReadMe/out/4roberts.png"; object-fit: contain; display: block; margin: 0 auto;">
    </td>
  </tr>
</table>
</div>

<h3>Laplaciano</h3>
<div align="center" style="margin: 20px 0;">
<table>
  <tr>
    <td>
      <img src="imagensReadMe/out/1laplace.png" ; object-fit: contain; display: block; margin: 0 auto;">
    </td>
    <td>
      <img src="imagensReadMe/out/2laplace.png"; object-fit: contain; display: block; margin: 0 auto;">
    </td>
    <td>
      <img src="imagensReadMe/out/3laplace.png"; object-fit: contain; display: block; margin: 0 auto;">
    </td>
    <td>
      <img src="imagensReadMe/out/4laplace.png"; object-fit: contain; display: block; margin: 0 auto;">
    </td>
  </tr>
</table>
</div>

---

<h2 id="execucao">4. Como Executar</h2>

<h3>1️⃣ Clone o repositório</h3>

<pre><code>git clone https://github.com/tamillycosta/Mi-Sistemas-Digitais-.git
</code></pre>

<hr>

<h3>2️⃣ Executar o Coprocessador no Quartus Prime</h3>
<ol>
  <li>Abra o Quartus Prime.</li>
  <li>No menu, vá em <strong>File &gt; Open Project</strong> e selecione o arquivo <code>.qpf</code> do projeto.</li>
  <li>Compile o projeto clicando em <strong>Compile</strong> no menu principal.</li>
  <li>Carregue o projeto na FPGA:
    <ul>
      <li>Vá em <strong>Tools &gt; Programmer</strong></li>
      <li>Selecione o arquivo <code>.sof</code> compilado.</li>
      <li>Envie para a placa <strong>DE1-SoC</strong> conectada via <strong>USB-Blaster</strong>.</li>
    </ul>
  </li>
</ol>

<hr>

<h3>3️⃣ Executar a Biblioteca Assembly no HPS</h3>
<ol>
  <li>Conecte-se ao HPS via SSH.</li>
  <li>Adicione os arquivos da pasta <code>Mi-Sistemas-Digitais-</code> ao HPS.</li>
  <li>Compile o projeto manualmente usando o seguinte comando:</li>
</ol>

<pre><code>gcc -Wall -Wextra -o programa main.c mulLib.c libAssembly.s -lrt -lm
</code></pre>

<ol start="4">
  <li>Execute o programa:</li>
</ol>

<pre><code>sudo ./programa
</code></pre>

<hr>

---
<h2 id="conclusao">5. Conclusão:</h2>

---
<h2 id="referencias">6. Referências Bibliográficas</h2>
<div align="justify">
  <ul>
    <li>GONZALEZ, Rafael C.; WOODS, Richard E. Digital image processing. 4. ed. global. Harlow: Pearson Education Limited, 2018.</li>
    <li>HIPR2. Roberts cross edge detector. University of Edinburgh, [s.d.]. Disponível em: https://homepages.inf.ed.ac.uk/rbf/HIPR2/roberts.htm. Acesso em: 5 jun. 2025.</li>
    <li>HIPR2. Sobel edge detector. University of Edinburgh, [s.d.]. Disponível em: https://homepages.inf.ed.ac.uk/rbf/HIPR2/sobel.htm. Acesso em: 4 jun. 2025.</li>
    <li>MARQUES, Oge. Processamento digital de imagens. [s.l.], 1999. Disponível em: https://www.ogemarques.com/wp-content/uploads/2014/11/pdi99.pdf. Acesso em: 3 jun. 2025.</li>
    <li>PINHO, Mário. Introdução ao processamento de imagens. Pontifícia Universidade Católica do Rio Grande do Sul (PUC-RS), [s.d.]. Disponível em: https://www.inf.pucrs.br/pinho/CGII/PDFs/IntroducaoProcImg.pptx.pdf. Acesso em: 3 jun. 2025.</li>
    <li>ROBOFLOW. Edge detection in computer vision: a comprehensive guide. Roboflow Blog, 2023. Disponível em: https://blog.roboflow.com/edge-detection/. Acesso em: 4 jun. 2025.</li>
    <li>ROBOFLOW. Laplacian edge detection. Roboflow Blog, 2023. Disponível em: https://blog.roboflow.com/edge-detection/#laplacian-edge-detection. Acesso em: 5 jun. 2025.</li>
    <li>VICERI, Rodrigo. Entendendo de vez a convolução: base para processamento de imagens. VICERI, 2021. Disponível em: https://viceri.com.br/insights/entendendo-de-vez-a-convolucao-base-para-processamento-de-imagens/. Acesso em: 3 jun. 2025.</li>
