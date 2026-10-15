# Publiczne, prywatne i lokalne ustawienia

## Co gdzie trafia

| Rodzaj | Miejsce | Przykłady |
|---|---|---|
| Ogólna konfiguracja i publiczna tożsamość | To repozytorium | Skróty, opcje edytora, Git LFS, `marcin@kotu.pl`, integracje Kiro/Codex |
| Konfiguracja związana z pracą | Osobne `dotfiles_private` | Służbowy e-mail, firmowe hosty/rejestry, aliasy projektowe |
| Sekrety i stan konkretnej maszyny | Lokalne pliki wyłączone z Git | Tokeny, hasła, certyfikaty i ich zawartość, historia sesji |

Prywatne repozytorium przechowuje konfigurację, **nie sekrety**.
Wersjonowane szablony mogą wskazywać potrzebę poświadczeń; właściwe wartości
są dostarczane lokalnie. Nie dodawaj URL zawierających login i token do Git.

## Jak działa tożsamość Git

`ln_gitconfig` zawiera osobisty adres i na końcu ładuje `~/.gitconfig-local`.
Prywatne repo dostarcza ten plik jako `ln_gitconfig-local`.

- Bez prywatnej warstwy domyślny jest publiczny adres osobisty.
- Z prywatną warstwą domyślny jest adres służbowy.
- Repozytorium lub konkretne polecenie Git może jawnie wybrać inną tożsamość.

Sprawdź efektywną wartość w konkretnym repozytorium:

```sh
git config --show-origin --get user.email
```

Przy publicznym commicie wybierz osobisty adres **także w metadanych commitu**:

```sh
git -c user.email=marcin@kotu.pl commit -m "Opis zmiany"
```

To ustawienie dotyczy tego wywołania i nie zmienia globalnego domyślnego adresu.
Nie ustawiaj przy tym służbowych `GIT_AUTHOR_EMAIL`/`GIT_COMMITTER_EMAIL`
w środowisku, bo mają pierwszeństwo przed konfiguracją Git.

## RubyGems

Publiczny `ln_gemrc` zawiera ogólne opcje i publiczny rejestr.
Prywatny `ln_gemrc` może być symlinkiem do ignorowanego `local/gemrc`.
Gdy lokalny plik istnieje, prywatna warstwa zastępuje publiczny link.
Gdy pliku brak, `link_configs` pomija ten wpis i pozostaje publiczna baza.

RubyGems nie jest tutaj konfigurowany przez include: prywatny plik jest
pełną konfiguracją. Aktualizując wspólne opcje, uwzględnij też prywatny szablon.
Pliku z tokenem nie wyświetlaj przez `git diff` i nie dodawaj go do indeksu.

## Linkowanie i sprawdzenie

Istniejący `install` linkuje publiczne pliki, a następnie sąsiednie
`dotfiles_private`. `functions:link_configs` wycina `ln_` z basename,
więc podkreślenia w ścieżce repo nie wpływają na nazwę pliku docelowego.
Nie uruchamiaj całego instalatora tylko po to, żeby zmienić jedną warstwę:
zawiera on również pobieranie zależności i konfigurację innych aplikacji.

Test linkowania i pierwszeństwa konfiguracji, bez zmian w prawdziwym HOME:

```sh
bash tests/link-configs.sh
```

## Przed commitem

1. Przejrzyj zmiany i przypisz je do jednej z trzech warstw.
2. Dodaj do indeksu tylko konkretne pliki wybranej zmiany.
3. Sprawdź staged diff, w tym nowe pliki i cele symlinków.
4. Sprawdź autora i committera, szczególnie w publicznym repo.
5. Utwórz oddzielne commity dla publicznej i prywatnej konfiguracji.

Zmiany w publicznych helperach OpenCode można commitować oddzielnie.
Zagnieżdżonego checkoutu private nie traktuj jako nowej konfiguracji do dodania.
