const buttonSend = document.getElementById("buttonSend");
const buttonClose = document.getElementById("buttonClose");
const buttonClose2 = document.getElementById("buttonClose2");
const buttonReset = document.getElementById("buttonReset");
const inputTitle = document.getElementById("inputTitle");
const inputMessage = document.getElementById("inputMessage");
const buttonPage1 = document.getElementById("buttonPage1");
const buttonPage2 = document.getElementById("buttonPage2");
const containerNachrichten = document.getElementById("nachrichtenContainer");
const containerNachrichtByID = document.getElementById("container3");
const statusText = document.getElementById("statusText");
const containerClosePlayers = document.getElementById("container4");

// Listeners

buttonSend.addEventListener("click", function () {
    sendText()
});

buttonPage1.addEventListener("click", function () {
    document.getElementById("container").style.display = "flex";
    document.getElementById("container2").style.display = "none";
});

buttonPage2.addEventListener("click", function () {

    openPageMyMessages()

});

async function openPageMyMessages() {
    try {
        const response = await fetch(`https://${GetParentResourceName()}/readData`, {
            method: "POST",

            headers: {
                "Content-Type": "application/json"
            },

            body: JSON.stringify({})
        });
        
        const messageData = await response.json()

        if (messageData.success) {

            containerNachrichten.innerHTML = "";

            messageData.messageData.forEach((messageData, index) => {
                const messageElement = document.createElement("div");
                messageElement.classList.add("message");

                const button = document.createElement("button");
                button.id = messageData.id;
                button.innerText = messageData.title;

                button.addEventListener("click", function () {
                    openMessage(messageData.id, messageData.title, messageData.message);
                });

                messageElement.appendChild(button);
                containerNachrichten.appendChild(messageElement);
            })


            document.getElementById("container").style.display = "none";
            document.getElementById("container2").style.display = "flex";
        } else {
            document.getElementById("container").style.display = "flex";
            document.getElementById("container2").style.display = "none";
            document.getElementById("container3").style.display = "none";
            statusText.textContent = "Du hast keine Einträge."
            await wait(5000);
            statusText.textContent = ""
        }

    } catch (error) {
        console.error("Error sending message:", error);
    }
}

async function giveMessageToPlayer(id) {
    try {
        const response = await fetch(`https://${GetParentResourceName()}/giveMessageToPlayer`, {
            method: "POST",

            headers: {
                "Content-Type": "application/json"
            },

            body: JSON.stringify({
                id: id,
            })
        });
        
        const closePlayers = await response.json()

        console.log(closePlayers.success)
        if (closePlayers.success) {

            containerClosePlayers.innerHTML = "";

            closePlayers.userData.forEach((userData, index) => {

                const button = document.createElement("button");
                button.innerText = userData.name;

                button.addEventListener("click", function () {
                    giveMessage(closePlayers.id, userData.name, userData.charID);
                });

                const button2 = document.createElement("button");
                button2.innerText = 'Zurück';

                button2.addEventListener("click", function () {
                    document.getElementById("container4").style.display = "none";
                    document.getElementById("container3").style.display = "flex";
                });

                containerClosePlayers.appendChild(button);
                containerClosePlayers.appendChild(button2);
            })


            document.getElementById("container3").style.display = "none";
            document.getElementById("container4").style.display = "flex";
        } else {
            document.getElementById("container").style.display = "flex";
            document.getElementById("container2").style.display = "none";
            document.getElementById("container3").style.display = "none";
            document.getElementById("container4").style.display = "none";
            statusText.textContent = "Keine Spieler in der nähe."
            await wait(5000);
            statusText.textContent = ""
        }

     } catch (error) {
         console.error("Error sending message:", error);
    }
}

async function giveMessage(messageID,name,charID) {
    try {
        const response = await fetch(`https://${GetParentResourceName()}/giveFinalMessageToPlayer`, {
            method: "POST",

            headers: {
                "Content-Type": "application/json"
            },

            body: JSON.stringify({
                id: messageID,
                name: name,
                charID: charID,
            })
        });
        
        const data = await response.json()

        if (data.success){
            document.getElementById("container").style.display = "flex";
            document.getElementById("container2").style.display = "none";
            document.getElementById("container3").style.display = "none";
            document.getElementById("container4").style.display = "none";
            statusText.textContent = `Nachricht an ${name} weitergegeben.`
        await wait(5000);
            statusText.textContent = ""
        }else {
            document.getElementById("container").style.display = "flex";
            document.getElementById("container2").style.display = "none";
            document.getElementById("container3").style.display = "none";
            document.getElementById("container4").style.display = "none";
            statusText.textContent = "Weitergabe nicht möglich!."
            await wait(5000);
            statusText.textContent = ""
        }
    } catch (error) {
         console.error("Error sending message:", error);
    }
}

// Wait Function
function wait(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

async function openMessage(id, title, message) {
    containerNachrichtByID.innerHTML = "";
    const messageElement = document.createElement("div");
    messageElement.classList.add("message");
    messageElement.innerHTML = `<h2>${title}</h2><p>${message}</p>`;

    const button = document.createElement("button");
    button.innerText = 'Nachricht Weitergeben';

    button.addEventListener("click", function () {
        giveMessageToPlayer(id)
    });

    const button2 = document.createElement("button");
    button2.innerText = 'Nachricht Löschen';

    button2.addEventListener("click", function () {
        deleteMessageFromDB(id)
    });

    const button3 = document.createElement("button");
    button3.innerText = 'Zurück';

    button3.addEventListener("click", function () {
        document.getElementById("container3").style.display = "none";
        document.getElementById("container2").style.display = "flex";
    });

    const button4 = document.createElement("button");
    button4.innerText = 'Schließen';

    button4.addEventListener("click", function () {
        closeMenu();
    });

    containerNachrichtByID.appendChild(messageElement);
    containerNachrichtByID.appendChild(button);
    containerNachrichtByID.appendChild(button2);
    containerNachrichtByID.appendChild(button3);

    document.getElementById("container2").style.display = "none";
    document.getElementById("container3").style.display = "flex";

}

async function deleteMessageFromDB(id) {
    try {
        const response = await fetch(`https://${GetParentResourceName()}/deleteMessageFromDB`, {
            method: "POST",

            headers: {
                "Content-Type": "application/json"
            },

            body: JSON.stringify({
                id: id,
            })
        });
            
        const getCallback = await response.json()

        if (getCallback.success) {
            document.getElementById("container3").style.display = "none";
            openPageMyMessages()
        } else {
            console.log('Fehler in Lua entdeckt');
        }
        

    } catch (error) {
            console.error("Error sending message:", error);
    }
}

buttonClose.addEventListener("click", function () {
    closeMenu();
});

buttonClose2.addEventListener("click", function () {
    closeMenu();
});

buttonReset.addEventListener("click", function () {
    inputTitle.value = "";
    inputMessage.value = "";
}); 

document.addEventListener("keydown", (event) => {

    if (event.key === "Escape") {
        closeMenu();
    }
});

// Functions

async function sendText() {
    try {
        const response = await fetch(`https://${GetParentResourceName()}/sendMessage`, {
            method: "POST",

            headers: {
                "Content-Type": "application/json"
            },

            body: JSON.stringify({
                title: inputTitle.value,
                message: inputMessage.value,
            })
        });
        
        const data = await response.json()

        if (data.success) {
            inputTitle.value = "";
            inputMessage.value = "";
        } else {
            console.error("Failed to send message:");
        }

    } catch (error) {
        console.error("Error sending message:", error);
    }
};

async function closeMenu() {
    fetch(`https://${GetParentResourceName()}/close`, {
        method: "POST",

        headers: {
            "Content-Type": "application/json"
        },

        body: JSON.stringify({})
    })
}

window.addEventListener("message", function (event) {

    const data = event.data;

    if (data.action === "open") {
        document.body.style.display = "flex";
        document.getElementById("container").style.display = "flex";
    }

    if (data.action === "close") {
        document.body.style.display = "none";
    }
});

