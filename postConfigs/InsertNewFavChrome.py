import json
from os import environ
from time import time

# Adiciona favorito no Google Chrome:
def insertFavChrome(file_path, fav_name, fav_url):
	with open(file_path) as favs:
		data = json.load(favs)

	last_id = data['roots']['bookmark_bar']['children'][-1]['id']

	next_id = str(int(last_id)+1)

	try:
		data['roots']['bookmark_bar']['children'].append(
		{
			"date_added": int(time()),
			"id": next_id,
			"name": fav_name,
			"type": "url",
			"url": fav_url
		})

		print(data['roots']['bookmark_bar']['children'][-1])

		f = open(file_path, 'w')

		json.dump(data, f)
		f.close()
		print('Favorito adicionado com sucesso!')
	
	except ValueError:
		print('Erro ao inserir favorito, por favor tente novamente.')

# Main - Insere o favorito no arquivo do usuário e no skel para próximos usuários a serem criados
def main():	
	fav_name = input('Insira o título do site a ser adicionado aos favoritos:\n')
	fav_url = input('Insira a url do site a ser adicionado aos favoritos:\n')
	fav_file = '%s/.config/google-chrome/Default/Bookmarks' % environ['HOME']
	insertFavChrome(fav_file, fav_name, fav_url)
	fav_file = '/etc/skel/.config/google-chrome/Default/Bookmarks'
	insertFavChrome(fav_file, fav_name, fav_url)

if __name__ == "__main__":
    main()

