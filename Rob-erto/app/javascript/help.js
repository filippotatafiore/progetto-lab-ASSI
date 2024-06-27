
let info = document.getElementById("info");
let funzione = document.getElementById("funzione");
let creators = document.getElementById("creators");
let content = document.getElementById("content");
function info(){
    funzione.addEventListener('click', function onClick(event) {
        event.target.style.color = 'greenyellow';
        funzione.style.color = 'black';
        creators.style.color = 'black';
     });
    content.innerHTML=`<h1> <b>Informazioni su Rob-erto</b> </h1>
                            <div class="bg-danger"></div>
                        `;
}
function funzioni(){
    funzione.addEventListener('click', function onClick(event) {
       event.target.style.color = 'greenyellow';
       info.style.color = 'black';
       creators.style.color = 'black';
    });
    content.innerHTML=`<h1> <b>Funzionalità del sito</b> </h1>
                        <div class="bg-danger"><h3> 
                            <ul>
                                <li> </div>
                        `;
}
function creators(){
    funzione.addEventListener('click', function onClick(event) {
        event.target.style.color = 'greenyellow';
        funzione.style.color = 'black';
        info.style.color = 'black';
        creators.style.color = 'black';
     });
    let info = document.getElementById("funzione");
    content.innerHTML=`<h1><b>Creatori di Rob-erto Rob-erto </b></h1>
                        <p> Filippo Simone ed Alessandro </p>
                        <h3> Alessandro ha perso 13 ore per provare a fare come dice la gente </h3>
                        <p> "noo non puoi chiamare una funzione js dentro lo span devi usare link_to e usare AJAX fare routing e dichiarare render: true e mettere il file js.erb nelle view e fare il controllore e e succhiare il cazzo a berlusconi come fanno tutti REEEEEEEEEEEEEEEEE" </p>
                        <h1> A ME NON FREGA UN CAZZO VAFFANCULO </h1>
                        <h5> uso onclick sullo span e non rompetem i coglioni</h5>
                        <p> NON DORMO DA 48 ORE AIUTOAIUTOAIUTOATIUAITOTOIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA </p>
                        `;
}