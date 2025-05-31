#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <math.h>
#include "multiplicacao.h"

//Guarda os dados de uma imagem .bmp
typedef struct{
    int largura; //largura da imagem em pixels
    int altura; //altura da imagem em pixels
    int profundidade; //tamanho em bits de cada pixel
    int pixelOffset; //offset dentro da imagem até os pixels
    int tamanhoImagem; //tamanho da imagem(nescessario para ler/escrver ela)
    int tamanhoLinha; //tamanho de 1 linha da imagem
    unsigned char* cabecalho; //ponteiro para array com o cabeçalho da imagem
    unsigned char* pixels; //ponteiro para array com os dados dos pixels
}imagem;


//Lê e coloca a imagm em escala de cinza, salvando no ponteiro de imagem
void leitorBmp(char* nomeArquivoLeitura, imagem* img);
//Escreve a imagem no arquivo
void salvarBmp(const char* nomeArquivoSaida, imagem* img);
//aplica o filtro de sobel na imagem
void sobel3x3(imagem* imagem);
//aplica filtro de sobel extendido na imagem
void sobel5x5(imagem* img);
//aplica o filtro de perwitt na imagem
void perwitt(imagem* img);
//aplica o filtro de roberts na imagem
void roberts(imagem* img);
//aplica o filtro de laplace
void laplace(imagem* img);


int main() {
    int opcaoImagem = 0;
    int opcaoFiltro = 0;
    char caminhoImagem[100];
    char caminhoSaida[120];
    char nomeFiltro[20];
    int sair = 0;

    while (!sair) {
        printf("\n=== MENU PRINCIPAL ===\n");
        printf("1. Selecionar Imagem\n");
        printf("2. Sair\n");
        printf("Escolha uma opcao: ");
        scanf("%d", &opcaoImagem);

        if (opcaoImagem == 2) {
            sair = 1;
            printf("\nSaindo do programa...\n\n");
            break;
        }

        // Escolha da imagem
        printf("\nEscolha uma imagem:\n");
        printf("1. 1.bmp\n");
        printf("2. 2.bmp\n");
        printf("3. 3.bmp\n");
        printf("Escolha: ");
        scanf("%d", &opcaoImagem);

        switch (opcaoImagem) {
            case 1:
                snprintf(caminhoImagem, sizeof(caminhoImagem), "imagens/input/1.bmp");
                break;
            case 2:
                snprintf(caminhoImagem, sizeof(caminhoImagem), "imagens/input/2.bmp");
                break;
            case 3:
                snprintf(caminhoImagem, sizeof(caminhoImagem), "imagens/input/3.bmp");
                break;
            default:
                printf("Opcao invalida! Voltando ao menu principal...\n\n");
                continue;
        }

        printf("Imagem selecionada: %s\n", caminhoImagem);

        imagem img;

        leitorBmp(caminhoImagem, &img);

        // Escolha do filtro
        printf("\nEscolha um filtro para aplicar:\n");
        printf("1. Sobel 3x3\n");
        printf("2. Sobel 5x5\n");
        printf("3. Prewitt\n");
        printf("4. Roberts\n");
        printf("5. Laplace\n");
        printf("Escolha: ");
        scanf("%d", &opcaoFiltro);

        switch (opcaoFiltro) {
            case 1:
                strcpy(nomeFiltro, "sobel3x3");
                printf("Filtro Sobel 3x3 selecionado.\n");
                sobel3x3(&img);
                break;
            case 2:
                strcpy(nomeFiltro, "sobel5x5");
                printf("Filtro Sobel 5x5 selecionado.\n");
                sobel5x5(&img);
                break;
            case 3:
                strcpy(nomeFiltro, "prewitt");
                printf("Filtro Prewitt selecionado.\n");
                perwitt(&img);
                break;
            case 4:
                strcpy(nomeFiltro, "roberts");
                printf("Filtro Roberts selecionado.\n");
                roberts(&img);
                break;
            case 5:
                strcpy(nomeFiltro, "laplace");
                printf("Filtro Laplace selecionado.\n");
                laplace(&img);
                break;
            default:
                printf("Opcao de filtro invalida!\n");
                continue;
        }

        // Criar caminho de saída
        snprintf(caminhoSaida, sizeof(caminhoSaida), "imagens/output/%d%s.bmp", opcaoImagem, nomeFiltro);

        salvarBmp(caminhoSaida, &img);

        printf("\nImagem salva em: %s\n\n", caminhoSaida);
    }

    return 0;
}


void sobel3x3(imagem* img){

    //espaço para colocar os pixels da imagem com o filtro
    unsigned char* comFiltro = malloc(img->tamanhoImagem * sizeof(unsigned char));

    // Máscaras Sobel 3x3 adaptadas para matriz 5x5 com zeros nos cantos
    int8_t sobely[5][5] = {
        {-1, -2, -1,  0,  0},
        { 0,  0,  0,  0,  0},
        { 1,  2,  1,  0,  0},
        { 0,  0,  0,  0,  0},
        { 0,  0,  0,  0,  0}
    };
    
    int8_t sobelx[5][5] = {
        {-1,  0,  1,  0,  0},
        {-2,  0,  2,  0,  0},
        {-1,  0,  1,  0,  0},
        { 0,  0,  0,  0,  0},
        { 0,  0,  0,  0,  0}
    };

    //percorre a todos os pixels da imagem
    for(int i = 0; i < img->altura; i++){
        int linha = img->altura - i - 1;

        for(int j = 0; j < img->largura; j++){
            //posição do pixel atual no vetor
            int posicao = linha * img->tamanhoLinha + j * (img->profundidade / 8);

            // Matriz temporária e resultados das multiplicações
            int8_t temp[5][5] = {0};
            int8_t mulx[5][5] = {0};
            int8_t muly[5][5] = {0};

            // Preenche a matriz 5x5 com vizinhança 3x3 centrada no pixel (com borda de zeros)
            for(int i2 = -1; i2 <= 1; i2++){
                for(int j2 = -1; j2 <= 1; j2++){
                    int linhaVizinha = i + i2;
                    int colunaVizinha = j + j2;

                    //confirma se as posições estão dentro dos limites da imegem
                    if(linhaVizinha >= 0 && linhaVizinha < img->altura &&
                       colunaVizinha >= 0 && colunaVizinha < img->largura){
                        
                        //posição do pixel vizinho atual no vetor
                        int posVizinho = (img->altura - linhaVizinha - 1) * img->tamanhoLinha + colunaVizinha * (img->profundidade / 8);
                        temp[i2 + 1][j2 + 1] = (img->pixels[posVizinho]+1)/2; 
                        // valor em tons de cinza, não precisa considerar cada cor
                        // valores divididos por 2 para garantir que o resultado não exceda 8bits
                    }
                }
            }

            // Multiplica pelas máscaras
            mult_tmp(temp, sobelx, mulx); //TODO: trocar pela função do coprocessador
            mult_tmp(temp, sobely, muly); //TODO: trocar pela função do coprocessador

            // Soma todos os valores das matrizes resultantes
            int somax = 0;
            int somay = 0;

            for(int k = 0; k < 5; k++){
                for(int l = 0; l < 5; l++){
                    //valores multiplicados antes da soma para compensar pela divisão feita antes
                    somax += mulx[k][l]*2;
                    somay += muly[k][l]*2;
                }
            }

            //eleva o resultado de ambas mascaras ao quadrado e  soma
            int novoValor = round(sqrt(pow(somax, 2)+pow(somay, 2)));
            //teste se o valor excedeu o limite de 8bits por cor na imagem
            if(novoValor > 255) novoValor = 255;

            // Escreve em RGB
            uint8_t resultadoFinal = (uint8_t) novoValor;
            comFiltro[posicao + 0] = resultadoFinal;
            comFiltro[posicao + 1] = resultadoFinal;
            comFiltro[posicao + 2] = resultadoFinal;
        }
    }

    //libera os pixels antigos e substitui pela versão com filtro
    free(img->pixels);
    img->pixels=comFiltro;
}


void sobel5x5(imagem* img){

    //espaço para colocar os pixels da imagem com o filtro
    unsigned char* comFiltro = malloc(img->tamanhoImagem * sizeof(unsigned char));

    // Máscaras Sobel 5x5
    int8_t sobely[5][5] = {
        {-1, -2,  0,  2,  1},
        {-4, -8,  0,  8,  4},
        {-6,-12,  0, 12,  6},
        {-4, -8,  0,  8,  4},
        {-1, -2,  0,  2,  1}
    };
    
    int8_t sobelx[5][5] = {
        {-1, -4, -6, -4, -1},
        {-2, -8,-12, -8, -2},
        { 0,  0,  0,  0,  0},
        { 2,  8, 12,  8,  2},
        { 1,  4,  6,  4,  1}
    };

    //percorre a todos os pixels da imagem
    for(int i = 0; i < img->altura; i++){
        int linha = img->altura - i - 1;

        for(int j = 0; j < img->largura; j++){
            //posição do pixel atual no vetor
            int posicao = linha * img->tamanhoLinha + j * (img->profundidade / 8);

            // Matriz temporária e resultados das multiplicações
            int8_t temp[5][5] = {0};
            int8_t mulx[5][5] = {0};
            int8_t muly[5][5] = {0};

            // Preenche a matriz 5x5 com vizinhança do pixel
            for(int i2 = -2; i2 <= 2; i2++){
                for(int j2 = -2; j2 <= 2; j2++){
                    int linhaVizinha = i + i2;
                    int colunaVizinha = j + j2;

                    //confirma se as posições estão dentro dos limites da imegem
                    if(linhaVizinha >= 0 && linhaVizinha < img->altura &&
                       colunaVizinha >= 0 && colunaVizinha < img->largura){
                        
                        //posição do pixel vizinho atual no vetor
                        int posVizinho = (img->altura - linhaVizinha - 1) * img->tamanhoLinha + colunaVizinha * (img->profundidade / 8);
                        temp[i2 + 2][j2 + 2] = (img->pixels[posVizinho]+1)/2; 
                        // valor em tons de cinza, não precisa considerar cada cor
                        // valores divididos por 2 para garantir que o resultado não exceda 8bits
                    }
                }
            }

            // Multiplica pelas máscaras
            mult_tmp(temp, sobelx, mulx); //TODO: trocar pela função do coprocessador
            mult_tmp(temp, sobely, muly); //TODO: trocar pela função do coprocessador

            // Soma todos os valores das matrizes resultantes
            int32_t somax = 0;
            int32_t somay = 0;

            for(int k = 0; k < 5; k++){
                for(int l = 0; l < 5; l++){
                    //valores multiplicados antes da soma para compensar pela divisão feita antes
                    somax += mulx[k][l]*2;
                    somay += muly[k][l]*2;
                }
            }

            //eleva o resultado de ambas mascaras ao quadrado e  soma
            int novoValor = round(sqrt(pow(somax, 2)+pow(somay, 2)));
            //teste se o valor excedeu o limite de 8bits por cor na imagem
            if(novoValor > 255) novoValor = 255;

            // Escreve em RGB
            uint8_t resultadoFinal = (uint8_t) novoValor;
            comFiltro[posicao + 0] = resultadoFinal;
            comFiltro[posicao + 1] = resultadoFinal;
            comFiltro[posicao + 2] = resultadoFinal;
        }
    }

    //libera os pixels antigos e substitui pela versão com filtro
    free(img->pixels);
    img->pixels=comFiltro;
}


void perwitt(imagem* img){

    //espaço para colocar os pixels da imagem com o filtro
    unsigned char* comFiltro = malloc(img->tamanhoImagem * sizeof(unsigned char));

    // Máscaras Perwitt 3x3 adaptadas para matriz 5x5 com zeros nos cantos
    int8_t perwitty[5][5] = {
        {-1, -1, -1,  0,  0},
        { 0,  0,  0,  0,  0},
        { 1,  1,  1,  0,  0},
        { 0,  0,  0,  0,  0},
        { 0,  0,  0,  0,  0}
    };
    
    int8_t perwittx[5][5] = {
        {-1,  0,  1,  0,  0},
        {-1,  0,  1,  0,  0},
        {-1,  0,  1,  0,  0},
        { 0,  0,  0,  0,  0},
        { 0,  0,  0,  0,  0}
    };

    //percorre a todos os pixels da imagem
    for(int i = 0; i < img->altura; i++){
        int linha = img->altura - i - 1;

        for(int j = 0; j < img->largura; j++){
            //posição do pixel atual no vetor
            int posicao = linha * img->tamanhoLinha + j * (img->profundidade / 8);

            // Matriz temporária e resultados das multiplicações
            int8_t temp[5][5] = {0};
            int8_t mulx[5][5] = {0};
            int8_t muly[5][5] = {0};

            // Preenche a matriz 5x5 com vizinhança 3x3 centrada no pixel (com borda de zeros)
            for(int i2 = -1; i2 <= 1; i2++){
                for(int j2 = -1; j2 <= 1; j2++){
                    int linhaVizinha = i + i2;
                    int colunaVizinha = j + j2;

                    //confirma se as posições estão dentro dos limites da imegem
                    if(linhaVizinha >= 0 && linhaVizinha < img->altura &&
                       colunaVizinha >= 0 && colunaVizinha < img->largura){
                        
                        //posição do pixel vizinho atual no vetor
                        int posVizinho = (img->altura - linhaVizinha - 1) * img->tamanhoLinha + colunaVizinha * (img->profundidade / 8);
                        temp[i2 + 1][j2 + 1] = (img->pixels[posVizinho]+1)/2; 
                        // valor em tons de cinza, não precisa considerar cada cor
                        // valores divididos por 2 para garantir que o resultado não exceda 8bits
                    }
                }
            }

            // Multiplica pelas máscaras
            mult_tmp(temp, perwittx, mulx); //TODO: trocar pela função do coprocessador
            mult_tmp(temp, perwitty, muly); //TODO: trocar pela função do coprocessador

            // Soma todos os valores das matrizes resultantes
            int somax = 0;
            int somay = 0;

            for(int k = 0; k < 5; k++){
                for(int l = 0; l < 5; l++){
                    //valores multiplicados antes da soma para compensar pela divisão feita antes
                    somax += mulx[k][l]*2;
                    somay += muly[k][l]*2;
                }
            }

            //eleva o resultado de ambas mascaras ao quadrado e  soma
            int novoValor = round(sqrt(pow(somax, 2)+pow(somay, 2)));
            //teste se o valor excedeu o limite de 8bits por cor na imagem
            if(novoValor > 255) novoValor = 255;

            // Escreve em RGB
            uint8_t resultadoFinal = (uint8_t) novoValor;
            comFiltro[posicao + 0] = resultadoFinal;
            comFiltro[posicao + 1] = resultadoFinal;
            comFiltro[posicao + 2] = resultadoFinal;
        }
    }

    //libera os pixels antigos e substitui pela versão com filtro
    free(img->pixels);
    img->pixels=comFiltro;
}


void roberts(imagem* img){

    //espaço para colocar os pixels da imagem com o filtro
    unsigned char* comFiltro = malloc(img->tamanhoImagem * sizeof(unsigned char));

    // Máscaras Roberts 3x3 adaptadas para matriz 5x5 com zeros nos cantos
    int8_t sobely[5][5] = {
        { 1,  0,  0,  0,  0},
        { 0, -1,  0,  0,  0},
        { 0,  0,  0,  0,  0},
        { 0,  0,  0,  0,  0},
        { 0,  0,  0,  0,  0}
    };
    
    int8_t sobelx[5][5] = {
        { 0,  1,  0,  0,  0},
        {-1,  0,  0,  0,  0},
        { 0,  0,  0,  0,  0},
        { 0,  0,  0,  0,  0},
        { 0,  0,  0,  0,  0}
    };

    //percorre a todos os pixels da imagem
    for(int i = 0; i < img->altura; i++){
        int linha = img->altura - i - 1;

        for(int j = 0; j < img->largura; j++){
            //posição do pixel atual no vetor
            int posicao = linha * img->tamanhoLinha + j * (img->profundidade / 8);

            // Matriz temporária e resultados das multiplicações
            int8_t temp[5][5] = {0};
            int8_t mulx[5][5] = {0};
            int8_t muly[5][5] = {0};

            // Preenche a matriz 5x5 com vizinhança 2x2 centrada no pixel (com borda de zeros)
            for(int i2 = 0; i2 <= 1; i2++){
                for(int j2 = 0; j2 <= 1; j2++){
                    int linhaVizinha = i + i2;
                    int colunaVizinha = j + j2;

                    //confirma se as posições estão dentro dos limites da imegem
                    if(linhaVizinha >= 0 && linhaVizinha < img->altura &&
                       colunaVizinha >= 0 && colunaVizinha < img->largura){
                        
                        //posição do pixel vizinho atual no vetor
                        int posVizinho = (img->altura - linhaVizinha - 1) * img->tamanhoLinha + colunaVizinha * (img->profundidade / 8);
                        temp[i2][j2] = (img->pixels[posVizinho]+1)/2; 
                        // valor em tons de cinza, não precisa considerar cada cor
                        // valores divididos por 2 para garantir que o resultado não exceda 8bits
                    }
                }
            }

            // Multiplica pelas máscaras
            mult_tmp(temp, sobelx, mulx); //TODO: trocar pela função do coprocessador
            mult_tmp(temp, sobely, muly); //TODO: trocar pela função do coprocessador

            // Soma todos os valores das matrizes resultantes
            int somax = 0;
            int somay = 0;

            for(int k = 0; k < 5; k++){
                for(int l = 0; l < 5; l++){
                    //valores multiplicados antes da soma para compensar pela divisão feita antes
                    somax += mulx[k][l]*2;
                    somay += muly[k][l]*2;
                }
            }

            //eleva o resultado de ambas mascaras ao quadrado e  soma
            int novoValor = round(sqrt(pow(somax, 2)+pow(somay, 2)));
            //teste se o valor excedeu o limite de 8bits por cor na imagem
            if(novoValor > 255) novoValor = 255;

            // Escreve em RGB
            uint8_t resultadoFinal = (uint8_t) novoValor;
            comFiltro[posicao + 0] = resultadoFinal;
            comFiltro[posicao + 1] = resultadoFinal;
            comFiltro[posicao + 2] = resultadoFinal;
        }
    }

    //libera os pixels antigos e substitui pela versão com filtro
    free(img->pixels);
    img->pixels=comFiltro;
}


void laplace(imagem* img){

    //espaço para colocar os pixels da imagem com o filtro
    unsigned char* comFiltro = malloc(img->tamanhoImagem * sizeof(unsigned char));

    // Máscara Laplace 5x5
    int8_t laplace[5][5] = {
        { 0,  0, -1,  0,  0},
        { 0, -1, -2, -1,  0},
        {-1, -2, 16, -2, -1},
        { 0, -1, -2, -1,  0},
        { 0,  0, -1,  0,  0}
    };

    //percorre a todos os pixels da imagem
    for(int i = 0; i < img->altura; i++){
        int linha = img->altura - i - 1;

        for(int j = 0; j < img->largura; j++){
            //posição do pixel atual no vetor
            int posicao = linha * img->tamanhoLinha + j * (img->profundidade / 8);

            // Matriz temporária e resultados da multiplicação
            int8_t temp[5][5] = {0};
            int8_t mul[5][5] = {0};

            // Preenche a matriz 5x5 com vizinhança do pixel
            for(int i2 = -2; i2 <= 2; i2++){
                for(int j2 = -2; j2 <= 2; j2++){
                    int linhaVizinha = i + i2;
                    int colunaVizinha = j + j2;

                    //confirma se as posições estão dentro dos limites da imegem
                    if(linhaVizinha >= 0 && linhaVizinha < img->altura &&
                       colunaVizinha >= 0 && colunaVizinha < img->largura){
                        
                        //posição do pixel vizinho atual no vetor
                        int posVizinho = (img->altura - linhaVizinha - 1) * img->tamanhoLinha + colunaVizinha * (img->profundidade / 8);
                        temp[i2 + 2][j2 + 2] = (img->pixels[posVizinho])/32; 
                        // valor em tons de cinza, não precisa considerar cada cor
                        // valores divididos por 2 para garantir que o resultado não exceda 8bits
                    }
                }
            }

            // Multiplica pelas máscara
            mult_tmp(temp, laplace, mul); //TODO: trocar pela função do coprocessador

            // Soma todos os valores das matrizes resultantes
            int32_t soma = 0;

            for(int k = 0; k < 5; k++){
                for(int l = 0; l < 5; l++){
                    //valores multiplicados antes da soma para compensar pela divisão feita antes
                    soma += mul[k][l]*32;
                }
            }

            //eleva o resultado de ambas mascaras ao quadrado e  soma
            int novoValor = abs(soma/4);
            //teste se o valor excedeu o limite de 8bits por cor na imagem
            if(novoValor > 255) novoValor = 255;

            // Escreve em RGB
            uint8_t resultadoFinal = (uint8_t) novoValor;
            comFiltro[posicao + 0] = resultadoFinal;
            comFiltro[posicao + 1] = resultadoFinal;
            comFiltro[posicao + 2] = resultadoFinal;
        }
    }

    //libera os pixels antigos e substitui pela versão com filtro
    free(img->pixels);
    img->pixels=comFiltro;
}


void leitorBmp(char* nomeArquivoLeitura, imagem* img) {
    FILE *streamIn = fopen(nomeArquivoLeitura, "rb");
    if (!streamIn) {
        printf("Erro ao abrir a imagem.\n");
        return;
    }
    

    // Lê os 14 primeiros bytes pra pegar o offset
    unsigned char headerTemp[14];
    fread(headerTemp, sizeof(unsigned char), 14, streamIn);

    if (headerTemp[0] != 'B' || headerTemp[1] != 'M') {
        printf("Erro: arquivo nao e um BMP valido.\n");
        fclose(streamIn);
        return;
    }


    int pixelDataOffset;
    memcpy(&pixelDataOffset, &headerTemp[10], sizeof(int));

    // Aloca e lê o cabeçalho completo até o início dos dados de pixel
    unsigned char* header = malloc(pixelDataOffset * sizeof(unsigned char));
    fseek(streamIn, 0, SEEK_SET);
    fread(header, sizeof(unsigned char), pixelDataOffset, streamIn);

    // Extrai as informações da imagem
    int width, height;
    unsigned short bitDepth;
    unsigned int compression;

    memcpy(&width,  &header[18], sizeof(int));
    memcpy(&height, &header[22], sizeof(int));
    memcpy(&bitDepth, &header[28], sizeof(unsigned short));
    memcpy(&compression, &header[30], sizeof(unsigned int));


    int bytesPerPixel = bitDepth / 8;
    int rowSize = (width * bytesPerPixel + 3) & (~3); // alinhamento de 4 bytes
    int imageSize = rowSize * height;

    // Lê os dados de pixels
    unsigned char* buf = malloc(imageSize * sizeof(unsigned char));
    fread(buf, sizeof(unsigned char), imageSize, streamIn);
    fclose(streamIn);

    // Converte em tons de cinza
    for (int i = 0; i < height; i++) {
        int linha = height - i - 1;
        for (int j = 0; j < width; j++) {
            int posicao = linha * rowSize + j * bytesPerPixel;
            unsigned char *b = &buf[posicao + 0];
            unsigned char *g = &buf[posicao + 1];
            unsigned char *r = &buf[posicao + 2];
            int media = (*r + *g + *b) / 3;
            *r = *g = *b = media;
        }
    }

    // Preenche os dados da struct
    img->largura = width;
    img->altura = height;
    img->profundidade = bitDepth;
    img->pixelOffset = pixelDataOffset;
    img->tamanhoImagem = imageSize;
    img->tamanhoLinha = rowSize;

    img->cabecalho = header;

    img->pixels = buf;
}


void salvarBmp(const char* nomeArquivoSaida, imagem* img) {
    FILE* fo = fopen(nomeArquivoSaida, "wb");
    if (!fo) {
        printf("Erro ao criar a imagem de saída.\n");
        return;
    }

    // Escreve o cabeçalho
    fwrite(img->cabecalho, sizeof(unsigned char), img->pixelOffset, fo);

    // Escreve os dados dos pixels
    fwrite(img->pixels, sizeof(unsigned char), img->tamanhoImagem, fo);

    fclose(fo);

    // Libera a memória alocada
    free(img->cabecalho);
    free(img->pixels);

    // Opcional: zera os ponteiros pra evitar dangling pointers
    img->cabecalho = NULL;
    img->pixels = NULL;
}

