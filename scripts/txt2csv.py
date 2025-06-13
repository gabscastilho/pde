import sys
import os

def converter_txt_para_csv(arquivo_entrada, arquivo_saida):
    """
    Converte um arquivo de texto com formato 'source target partition'
    para um arquivo CSV com cabeçalho 'Source,Target,Partition'.

    Args:
        arquivo_entrada (str): O caminho para o arquivo de texto de entrada.
        arquivo_saida (str): O caminho para o arquivo CSV de saída.
    """
    try:
        print(f"Iniciando a conversão de '{arquivo_entrada}' para '{arquivo_saida}'...")

        # Abrindo os dois arquivos: um para leitura (entrada) e outro para escrita (saída)
        with open(arquivo_entrada, 'r') as f_in, open(arquivo_saida, 'w') as f_out:
            # 1. Escreve o cabeçalho no arquivo CSV
            f_out.write("Source,Target,Partition\n")

            # 2. Itera sobre cada linha do arquivo de entrada
            contador_linhas = 0
            for linha in f_in:
                # Remove espaços em branco do início e do fim da linha
                linha_limpa = linha.strip()

                # Ignora linhas em branco
                if not linha_limpa:
                    continue

                # Separa os valores baseados em espaços (ou tabs)
                # .split() sem argumentos lida com múltiplos espaços e tabs
                partes = linha_limpa.split()

                # Verifica se a linha tem o formato esperado (3 colunas)
                if len(partes) == 3:
                    source, target, partition = partes
                    # Escreve a linha formatada como CSV
                    f_out.write(f"{source},{target},{partition}\n")
                    contador_linhas += 1
                else:
                    print(f"Aviso: Ignorando linha mal formatada: '{linha_limpa}'")

        print(f"Conversão concluída com sucesso! {contador_linhas} linhas de dados foram processadas.")
        print(f"Arquivo CSV salvo em: '{arquivo_saida}'")

    except FileNotFoundError:
        print(f"Erro: O arquivo de entrada '{arquivo_entrada}' não foi encontrado.")
    except Exception as e:
        print(f"Ocorreu um erro inesperado: {e}")


if __name__ == "__main__":
    # Pega o nome do arquivo de entrada a partir dos argumentos da linha de comando
    if len(sys.argv) < 2:
        print("Uso: python converter_para_csv.py <caminho_para_o_arquivo_txt>")
        sys.exit(1)

    caminho_entrada = sys.argv[1]

    # Gera o nome do arquivo de saída trocando a extensão para .csv
    # Ex: 'meus_dados.txt' -> 'meus_dados.csv'
    nome_base, _ = os.path.splitext(caminho_entrada)
    caminho_saida = nome_base + ".csv"

    converter_txt_para_csv(caminho_entrada, caminho_saida)