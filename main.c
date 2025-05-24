#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>

//Guarda os dados de uma imagem .bmp
typedef struct{
    int largura; //largura da imagem em pixels
    int altura; //altura da imagem em pixels
    int profundidade; //tamanho em bits de cada pixel
    int pixelOffset; //offset dentro da imagem até os pixels
    int tamanhoImagem; //tamanho da imagem(nescessario para ler/escrver ela)
    unsigned char* cabecalho; //ponteiro para array com o cabeçalho da imagem
    unsigned char* pixels; //ponteiro para array com os dados dos pixels
}imagem;


//Lê e coloca a imagm em escala de cinza, salvando no ponteiro de imagem
void leitorBmp(char* nomeArquivoLeitura, imagem* img);
//Escreve a imagem no arquivo
void salvarBmp(const char* nomeArquivoSaida, imagem* img);//Escreve a imagem no arquivo


int main(){
    imagem img;
    leitorBmp("imagens/input/3.bmp", &img);
    printf("altura: %d\nlargura: %d\nprofundidade: %d\n", img.altura, img.largura, img.profundidade);
    salvarBmp("imagens/output/3Out.bmp", &img);
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
    printf("?pixeldataoffset: %d\n", pixelDataOffset);

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

    printf("altura: %d\nlargura: %d\nprofundidade: %d\n", height, width, bitDepth);

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

    img->cabecalho = header;

    img->pixels = buf;

    // Impressão opcional de debug
    printf("altura: %d\nlargura: %d\nprofundidade: %d\n", width, height, bitDepth);
    printf("Compressao: %d\n", compression);
    printf("Offset: %d\n", pixelDataOffset);
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

