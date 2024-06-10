
function openPopup() {
    let popup = document.getElementById("img-window");
    popup.classList.add("open-popup");
}

function closePopup() {
    let popup = document.getElementById("img-window");
    popup.classList.remove("open-popup");
}

// async function caricaImmagine(x) {

//     let datiDaInviare = {
//         username: get('username'),
//         immagine: x,
//         operazione: 'setImmagineProfilo'
//     };

//     let datiRicevuti = await inviaDatiAlServer(datiDaInviare);

//     if (datiRicevuti['messaggio'] == 'Immagine profilo caricata') {
//         //console.log("Immagine caricata nel server");
//         aggiornaProfilo();
//     }

//     closePopup();
// }



// per ogni immagine imgx.png profilo in assets/profili, aggiungi l'img a id='immaginiProfilo', ciascuna con classe popup-img e onclick='caricaImmagine(x)'
for (var i = 0; i < assetPaths.length; i++) {
    let img = document.createElement('img');
    img.src = assetPaths[i];
    img.classList.add('popup-img');
    img.setAttribute('onclick', 'caricaImmagine(' + i + ')');
    document.getElementById('immaginiProfilo').appendChild(img);
}