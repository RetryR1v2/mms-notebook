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
const containerEditMessage = document.getElementById("container5");

// Load Translations

let Translation = {};

async function loadTranslation() {
    const getLang = await fetch(`https://${GetParentResourceName()}/getLang`, {
           method: "POST",

        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({})
    });
        
    const lang = await getLang.json()
        
    if (lang.success) {
        const response = await fetch(`locales/${lang.lang}.json`);
        Translation = await response.json();
        
        document.querySelectorAll("[data-i18n]").forEach(function(element) {
            const key = element.getAttribute("data-i18n");
            element.innerText = Translation[key];
        });

        document.querySelectorAll("[data-i18n-placeholder]").forEach(function(element) {
            const key = element.getAttribute("data-i18n-placeholder");
            element.placeholder = Translation[key];
        });
    } else {
        const response = await fetch(`locales/de.json`);
        Translation = await response.json();

        document.querySelectorAll("[data-i18n]").forEach(function(element) {
            const key = element.getAttribute("data-i18n");
            element.innerText = Translation[key];
        });

        document.querySelectorAll("[data-i18n-placeholder]").forEach(function(element) {
            const key = element.getAttribute("data-i18n-placeholder");
            element.placeholder = Translation[key];
        });
    }

}

loadTranslation();


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
            statusText.textContent = Translation.no_entrys
            await wait(5000);
            statusText.textContent = ""
        }

    } catch (error) {
        console.error(Translation.status_error, error);
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
                button2.innerText = Translation.button_back;

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
            statusText.textContent = Translation.no_near_players
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
            statusText.textContent = `${Translation.message_to} ${name} ${Translation.message_to2}`
        await wait(5000);
            statusText.textContent = ""
        }else {
            document.getElementById("container").style.display = "flex";
            document.getElementById("container2").style.display = "none";
            document.getElementById("container3").style.display = "none";
            document.getElementById("container4").style.display = "none";
            statusText.textContent = Translation.cant_message_to
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
    button.innerText = Translation.edit_message_button;

    button.addEventListener("click", function () {
        
        editMessage(id, title, message)

    });

    const button2 = document.createElement("button");
    button2.innerText = Translation.give_message_button;

    button2.addEventListener("click", function () {
        giveMessageToPlayer(id)
    });

    const button3 = document.createElement("button");
    button3.innerText = Translation.delete_message_button;

    button3.addEventListener("click", function () {
        deleteMessageFromDB(id)
    });

    const button4 = document.createElement("button");
    button4.innerText = Translation.button_back;

    button4.addEventListener("click", function () {
        document.getElementById("container3").style.display = "none";
        document.getElementById("container2").style.display = "flex";
    });


    containerNachrichtByID.appendChild(messageElement);
    containerNachrichtByID.appendChild(button);
    containerNachrichtByID.appendChild(button2);
    containerNachrichtByID.appendChild(button3);
    containerNachrichtByID.appendChild(button4);

    document.getElementById("container2").style.display = "none";
    document.getElementById("container3").style.display = "flex";

}

async function editMessage(id, title, message) {
    try {
        containerEditMessage.innerHTML = "";

        const head1 = document.createElement("h2");
        head1.innerText = Translation.head_edit_message_button;

        const inputArea = document.createElement("input");
        inputArea.type = 'text';
        inputArea.value = title;

        const textArea = document.createElement("textarea");
        textArea.rows = '10';
        textArea.cols = '50';
        textArea.value = message;

        const button = document.createElement("button");
        button.innerText = Translation.save_message_button;

        const button2 = document.createElement("button");
        button2.innerText = Translation.button_back;

        button.addEventListener("click", function () {
            saveEditedMessage(id, inputArea.value, textArea.value)
        });

        button2.addEventListener("click", function () {
            document.getElementById("container3").style.display = "flex";
            document.getElementById("container5").style.display = "none";
        });

        containerEditMessage.appendChild(head1);
        containerEditMessage.appendChild(inputArea);
        containerEditMessage.appendChild(textArea); 
        containerEditMessage.appendChild(button);
        containerEditMessage.appendChild(button2);


        document.getElementById("container3").style.display = "none";
        document.getElementById("container5").style.display = "flex";

    } catch (error) {
            console.error("Error sending message:", error);
    }
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
            console.log('Error in Lua Code Ask Developer');
        }
        

    } catch (error) {
            console.error("Error sending message:", error);
    }
}

async function saveEditedMessage(id, title, message) {
    try {
        const response = await fetch(`https://${GetParentResourceName()}/saveEditedMessage`, {
            method: "POST",

            headers: {
                "Content-Type": "application/json"
            },

            body: JSON.stringify({
                id: id,
                title: title,
                message: message,
            })
        });
            
        const getCallback = await response.json()

        if (getCallback.success) {
            document.getElementById("container").style.display = "flex";
            document.getElementById("container2").style.display = "none";
            document.getElementById("container3").style.display = "none";
            document.getElementById("container4").style.display = "none";
            document.getElementById("container5").style.display = "none";
            statusText.textContent = Translation.message_edited_successfully
            await wait(5000);
            statusText.textContent = ""
        } else {
            console.log('Fehler in Lua entdeckt');
        }
        

    } catch (error) {
            console.error("Error sending message:", error);
    }
}

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
        if (inputTitle.value.trim() !== "" && inputMessage.value.trim() !== ""){
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
        } else {
            statusText.textContent = Translation.fill_all_fields
            await wait(5000);
            statusText.textContent = ""
        }

    } catch (error) {
        console.error("Error sending message:", error);
    }
};

async function closeMenu() {
    try {
        const response = await fetch(`https://${GetParentResourceName()}/close`, {
            method: "POST",

            headers: {
                "Content-Type": "application/json"
            },

            body: JSON.stringify({})
        });
        
        const data = await response.json()

    } catch (error) {
        console.error("Error sending message:", error);
    }
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