
const BASE_URL = "http://localhost:3001";
const MESSAGE_ATTRIBUTE = '.line-layout-row .line-layout-row__username';

////////////////////////////////////////////////////////////////////////

const FETCH = {
    
    // returns most recent message form server
    getLatest: async () => {
        try {
            const response = await fetch(`${BASE_URL}/chatroom-latest-message`);
            const data = await response.json();
            if ( data ) {
                return data;
            }
        } catch(e) {
            console.log(e);
        }
    
        return false;
    },
    
    // posts message data to server, (messages) should be an array
    postData: async ( messages ) => {
        try {
            const jsonData = JSON.stringify( messages );
            const options  = { 
                method: 'put' , 
                'Content-Type': 'application/json', 
                body: jsonData 
            };

            const response = await fetch( `${BASE_URL}/chatroom-data-upload`, options );
            const data = await response.json();
            
            if ( data ) {
                return data;
            }

        }catch(e) {
            console.log(e);
        }
    
        return false;
    }
}



const isLast = ( ind, array ) => {
    return  array.length === ind;
}

// finds index based off author & content -> Chat Message
// message: { author: string , content: string}
// messageList: [message]
// returns: integer

const findIndexOf = ( message, messageList ) => {
    return messageList.findIndex( ( m ) => {
         return m.author === message.author && 
                m.content === message.content
     })
 }

// looks through DOM for all chat messages
// returns: [{ author: string, content: string }] | []

const takeMessages = () => {
    let messages = [...document.querySelectorAll(MESSAGE_ATTRIBUTE)];
    if ( messages ) {
        return messages.reduce( (acc,author) => {
            let content = author.nextElementSibling;
            acc.push({
                author: author.innerText.trim(),
                content: content.innerText.trim()
            })

            return acc;
        }, [])
    }

    return [];
}


// checks if server is up to date with all client messages
// if most recent server message is not found in DOM, 
// assume that all messages are new
// return value shows index of most recent server message and array of clientMessages
// returns: [integer, [{author: string, content: string}]] | [false]

const findMostRecent = async () => {
    const mostRecentServerMessage = await FETCH.getLatest();
    if ( mostRecentServerMessage ) {
        let clientMessages = takeMessages();
        let recentMessageIndex = findIndexOf(mostRecentServerMessage, clientMessages);

        if ( recentMessageIndex === -1 ) {
            clientMessages.unshift(null);
            return [ 1,  clientMessages];
        }
        return [ ( recentMessageIndex + 1 ), clientMessages ];
    }

    return [ false ];
}


const updateMessageData = async () => {
    const [ index, clientMessages ] = await findMostRecent();
    if ( index  && !isLast( index, clientMessages )) {
        const newMessages = clientMessages.splice( index );
        const res = await FETCH.postData( newMessages );
        if ( res ) {
            return res;
        } 
    }
}



// main
window.onload = () => {
    setInterval( updateMessageData, 10000 )
}



// need to know
// 1. chat site url for manifest.json
