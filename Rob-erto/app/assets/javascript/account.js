let username = document.querySelector('.username').dataset.username;
let token = document.querySelector('[name="csrf-token"]').content;

function openPopup() {
    let popup = document.getElementById("img-window");
    popup.classList.add("open-popup");
}

function closePopup() {
    let popup = document.getElementById("img-window");
    popup.classList.remove("open-popup");
}

async function caricaImmagine(x) {
    let imageID = x+1;
    let datiDaInviare = {
        image: imageID,
    };

    let response = await fetch(`/users/${username}/update_profile_image`, {
        method: 'PATCH',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': token
        },
        body: JSON.stringify(datiDaInviare)
    });

    let datiRicevuti = await response.json();

    if (datiRicevuti['message'] == 'Immagine profilo caricata') {
        document.querySelector('.avatar').src = assetPaths[x];
    }

    closePopup();
}



// per ogni immagine imgx.png profilo in assets/profili, aggiungi l'img a id='immaginiProfilo', ciascuna con classe popup-img e onclick='caricaImmagine(x)'
for (var i = 0; i < assetPaths.length; i++) {
    let img = document.createElement('img');
    img.src = assetPaths[i];
    img.classList.add('popup-img');
    let imgId = 'img-' + (i+1);
    img.classList.add(imgId);
    img.setAttribute('onclick', 'caricaImmagine(' + i + ')');
    document.getElementById('immaginiProfilo').appendChild(img);
}