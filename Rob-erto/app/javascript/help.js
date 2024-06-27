
let informazione = document.getElementById("info");
let funzione = document.getElementById("funzione");
let creators = document.getElementById("creators");
let content = document.getElementById("content");
function info(){
    informazione.className = "stileinfoattiva";
    funzione.className = "stileinfo";
    creators.className = "stileinfo";


    content.innerHTML=`<h1 class="d-flex justify-content-center"> <b>Introduzione su Rob-erto</b> </h1>
                            <div class="p-4 mx-3">Rob-erto è un chatbot che sfrutta l'API di GroqCloud per conversare con modelli di intelligenza artificiale. Grazie a GroqCloud, Rob-erto è in grado di rispondere, 
                            correggere errori nelle domande e aiutare l'user nel modo più dettagliato possibile.</div>
                        `;
}
function funzioni(){
    informazione.className = "stileinfo";
    funzione.className = "stileinfoattiva";
    creators.className = "stileinfo";


    content.innerHTML=`<h1 class="d-flex justify-content-center"> <b>Ruoli e diritto di accesso alle funzionalità</b> </h1>
                        <div class="mx-3 d-flex">Il sito offre 3 diversi ruoli con le loro rispettive funzionalità:</div>
                        <ul class="mx-3">
                            <li><b>Base user:</b> è l'utente che apre l'applicazione web senza registrarsi. Il Base user può:</li>
                            <div class="d-flex text-start">
                                <ul>
                                    <li>comunicare con l'AI attraverso un'unica chat</li>
                                    <li> traduzione dei messaggi</li>
                                    <li>reinvio o l'eliminazione del messaggio.</li>
                                </ul>
                            </div>
                            <li><b>Registered user:</b> è l'utente registratosi nella sezione Profilo della barra di navigazione. Il Registered user può:</li>
                            <div class="d-flex text-start">
                                <ul>
                                    <li>creare e passare da una chat all'altra</li>
                                    <li>eliminare e rinominare una chat</li>
                                    <li>segnare una chat come importante (apparirà in cima alla lista chat)</li>
                                    <li>vedere e mandare le domande suggerite dall'APP all'AI</li>
                                    <li>mandare e ricevere richieste di amicizia ad altri registered user</li>
                                    <li>condividere le chat con i suoi amici</li>
                                    <li>cambiare o eliminare la sua immagine profilo</li>
                                </ul>
                            </div>
                            <li><b>Pro user:</b> è l'utente <i>registrato</i> che ha pagato per la versione pro nela sezione Profilo. Il Pro user può:</li>
                            <div class="d-flex text-start">
                                <ul>
                                    <li>cambiare il modello dell'AI</li>
                                    <li>cambiare il colore del chatbox e del font</li>
                                    <li>cambiare il proprio nickname</li>
                                </ul>
                            </div>
                        </ul>
                        </div>
                        `;
}
function creatori(){
    informazione.className = "stileinfo";
    funzione.className = "stileinfo";
    creators.className = "stileinfoattiva";
    
    


    content.innerHTML=`<h1 class="d-flex justify-content-center"><b>Creatori di Rob-erto</b> </h1>
                        <div class=" d-flex justify-content-center p-4">
                            <h3>
                            <div class=" p-2 mt-5">   Filippo Tatafiore     tatafiore.1934988@studenti.uniroma1.it<br></div>
                            <div class=" p-2 mt-5">   Simone Nolè           nole.1940213@studenti.uniroma1.it<br></div>
                            <div class=" p-2 mt-5">   Alessandro Cannone    cannone.2009032@studenti.uniroma1.it </div> 
                            </h3>
                        <div>
                        `;
}