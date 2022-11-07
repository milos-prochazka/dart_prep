# **dart\_prep**
Dart preprocesor slouží k podmíněnému překladu programů v jazyce dart (je kompatiblní s javou,  javascriptem a c#).
## **Syntaxe : dart\_prep** 
**Argumenty:**

- název_adresáře - Adresář který bude zpracován. Zpracovány budou všechny dart soubory ve všech podadresářích.
- název_souboru - Název dart souboru který bude zpracován.
- @název_konfiguračního_souboru - Konfigurační soubor obsahující volby.
- +název - Přidání definovaného názvu. Tento název je od své definice považován za existující a všechny odkazy na něj jsou pravdivé.
- -název - Odstranění dříve definovaného názvu. Všechny následující odkazy na něj budou považovány za nepravdivé.
- #.ext - Nastaví rozšíření (typ souboru) které bude používáno pro prohledávání adresářů. Implicitní hodnota je .dart. Souží pro zpracování jiných jazyků  než dart (#.java pro zpracování javy).


Argumenty se zpracovávají postupně zleva doprava. Zadání **´dart\_prep  file1.dart   +test  file2.dart´** zpracuje **file1.dart** bez definovaného názvu **test** a **file2.dart** s definovaným **test**.
## **Syntaxe souborů**
- Program označuje řádky vyřezené z podmíněného překladu komentářem **//##**.
- Prepoprcesor pracuje po řádích, Každý příkaz je na začátku řádku
- Blok podmíněného překladu začíná podmínkou **//#if** 
- Blok **//#if** může obsahovat několik  bloků  **//#elif** a blok  **//#else**
- Blok **//#if** je zakončen příkazem **//#end**.
- Je možno použít také jednoduché podmínky **//#debug** **//#release** a **//#verbose**.
  - Tyto podmínky testují existenci příslušného názvu (debug,release a verbose) a nemohou obsahovat else a elif části.
- Pro definování v názvů v rámci souboru se používá příkaz **//#define** . Zpracování konfiguračního a běžného souboru se liší v tom, že definice v konfiguračním souboru jsou viditelné ve všech později zpracovávaných souborech, kdežto definice v běžném souboru jsou viditelné pouze v rámci danného souboru.
- Preprocesor podporuje definice znakových konstant. Například konstanta 'A' (znak A v syntaxi jazyka C) se zapíše jako **/\*$A\*/** .
  - Teto zápis bude nahrazen výrazem  **/\*$A\*/0x41**. Jsou podporovány escape sekvence například '**\n**' se zapíše jako **/\*$\n\*/**.
  - Program podporuje standardní escape **\\** , **\r** , **\n** , **\t** , **\v** , **\b** , **\f** , **\a** , **\e** 
  - Pro zadání lomítka slouží escape **\s**

**Syntaxe podmínky if**

- Syntaxe podmínky if se skládá z názvů , operátorů a závorek.
- if podporuje operátory **|**  (logický součet) a  **&** (logický součin). Logický součin má vyšší prioritu).
- V rámci if je možno použít také negaci (**!**), pro negování podmínky, závorky a předdefinované konstanty (**0, 1, true, false**).

**Syntaxe define**

- Parametrem define je prostý seznam definovaných názvů.
- V rámci define je možno před název zapsat !. Tím se odstraní dříve definovaný název.


