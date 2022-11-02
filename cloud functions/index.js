const functions = require("firebase-functions");

const admin = require("firebase-admin");
const uuid = require('uuid');
const util = require('util');
const { object } = require("firebase-functions/v1/storage");
const { firebaseConfig } = require("firebase-functions");
const sleep = util.promisify(setTimeout);

var botNames = ['Joker', 'Chappie', 'Dragon', 'Cuddles', 'Coyote', 'Dice', 'Renes', 'Streak',
    'Onccafe', 'Ulubey', 'Cudi', 'Matthew', 'Topalpire', 'Lotus', 'Raven', 'DonJuan',
    'DeMarco', 'JulSezer', 'AleaIacta', 'Romulus', 'Potrkt', 'Nessajj', 'Bthnywz',
    'Tanksavar', 'Ayıbogan', 'Gedikli', 'Fettansultan', 'Legolas', 'Aragorn',
    'Oramakomaburamako', 'Opajjj', 'Goaway', 'YalanMusk', 'Kerimoglu', 'Adamsmith',
    'Gandalf', 'Tarama63', 'Resatbalik', 'Dogdugunesim', 'Hayrolababa', 'Tirsiksos',
    'Sifaciusta', 'Karnelt', 'Baldvindort', 'Jekremjimamoglu', 'Jansurjavas', 'Kakaleyto',
    'Abrahamslrty', 'Kardesimyapma', 'Tiktokcuadam', 'Merkfotlyf', 'Darwiningotu',
    'Pabloesco22', 'Geliyorumulkem34', 'Brick', 'Crystal', 'Diamondtema', 'Baldy',
    'Jahrein', 'Elraenn', 'PurpleBixi', 'Agabune', 'Rerdogan', 'Chpninkalesi',
    'Solcenah', 'Siyasalislamci', 'Amanyh22', 'S2p60', 'Takashivucunayde', 'Widowscgy',
    'Norlty', 'Tahfrtyg', 'Aleppo', 'Arsuf', 'Ayaz', 'Bulut', 'Ebenryf', 'Sekizincihenri',
    'Torryhpy', 'Silkroadcicocuk', 'Metin2ci', 'Sedatpeker', 'Yelizciis4g', 'Kardesnaber',
    'Noluyoyaa', 'Barisozcan', 'Buradayimbende', 'Pretzell', 'Butcher245', 'Rustyreis',
    'Rebellionut', 'Locomotive', 'Maniasry', 'Toonnlar', 'Sillyoft', 'Zeromanyi',
    'Karefıy', 'Oltgkt33', 'Cokyahsii', 'Oyuncuadam', 'Canmanay', 'Canyaman',
    'Amoranth', 'Kalektm', 'Succotash', 'Aexetan', 'NarrowVictory',
    'Presbiopic', 'Scoundrella', 'MuttonChops', 'OwlChick', 'Parley',
    'TechCluster', 'HaelSturm', 'Incandescent', 'Assaultive', 'Underfire',
    'RingRaid', 'Bibliokiller', 'Mildewed', 'Rhenus', 'Presbiopic', 'Rubrick',
    'HaelSturm', 'Gerbilator', 'Pralltiller', 'PandoraBox', 'MyrtleGirl',
    'FlowerPower', 'Dustbunny', 'Papaur', 'Hornaceous', 'ImpPlant', 'Redshock',
    'Margary', 'Cothurnal', 'BizzyBee', 'LlamaDrama', 'MiGrain', 'Underfire',
    'Slyrack', 'Opally', 'BeardDemon', 'Overseer', 'MacroMadam', 'Capitulation',
    'Valance', 'Robotik', 'Sharkgirl', 'Prysm', 'OgreMan', 'BizzyBee',
    'Bibliokiller', 'Rigamarole', 'Parley', 'Marling', 'Cothurnal',
    'Bibliokiller', 'Rigamarole', 'CaesarJ', 'MuscleMa', 'ThunderHawk',
    'EarthMother', 'Mortician', 'MyrtleGirl', 'Pilar', 'LlamaDrama',
    'Redemptor', 'Saddlewitch', 'Megalith', 'Sceptre', 'RustySilver',
    'Shakeawake', 'WillHunting', 'KnifeRing', 'Chinaplate', 'Margary',
    'Crucifery', 'Palanquin', 'AnarKiss', 'CatInHat', 'AttackAttack',
    'Shadowhunter', 'SalvoStrike', 'MuttonChops', 'Rubrick', 'Possumiss',
    'OrangeGlade', 'Margary', 'RumpleThump', 'LlamaDrama', 'HodgePodge',
    'BatonRelay', 'Salamandrine', 'MarchHare', 'SepiaTone', 'SaffronYellow',
    'GrimReap', 'Reformer', 'Kalazah', 'Rilunaeth', 'Yhost', 'Pherys',
    'Mibriam', 'Elahorn', 'Mikesh', 'Riggery', 'Pyricles', 'Rorys', 'Zraek',
    'Ingbert', "Frances", "Fan", "Fanne", "Fanny", "Fanney", "Fran", "Sis",
    "Cisse", "Cissy", "Cissey", "Hepsabah", "Hepse", "Hepsy", "Hepsey",
    "Hepsibah", "Hephsibah", "Hebsabeth", "Hepsabel", "Elizabeth",
    "Rosabella", "Josephine", "Josepha", "Phene", "Pheny", "Pheney",
    "Jo", "Joey", "Jose", "Josy", "Josey", "Fina", "Jode", "Jody",
    "Jodey", "Lawrence", "Larre", "Larry", "Larrey", "Lars", "Laurence",
    "Lawre", "Lawry", "Lawrey", "Lon", "Lorre", "Lorry", "Lorrey",
    "Lonne", "Lonny", "Lonney", "Lorne", "Daisey", "Greta", "Madge",
    "Magge", "Maggy", "Maggey", "Maise", "Maisy", "Maisey", "Marge",
    "Margo", "Peg", "Meg", "Metta", "Midge", "Pegge", "Peggy",
    "Peggey", "Margaretha", "Meta", "Gretta", "Rita", "Margere",
    "Margery", "Margerey", "Marjore", "Marjory", "Marjorey", "Marge",
    "Margy", "Margey", "Margaretta", "Megan", "Mary", "Margarita",
    "Mary", "Mae", "Mame", "Mamy", "Mamey", "Marietta", "Marion",
    "Maureen", "May", "Merce", "Mercy", "Mercey", "Minne", "Minny",
    "Minney", "Mitze", "Mitzy", "Mitzey", "Molle", "Molly",
    "Molley", "Polle", "Polly", "Polley", "Moll", "Mime", "Mimy",
    "Mimey", "Mate", "Maura", "Moira", "Marilyn", "Maria",
    "Mariah", "Marian", "Mare", "Mary", "Marey", "Marcia",
    "Marica", "Maryanne", "Martha", "Margaret", "Winifred",
    "Fredde", "Freddy", "Freddey", "Winne", "Winny", "Winney",
    "Winnet", "Wenefred", "Fred", "William", "Bill", "Will",
    "Wille", "Willy", "Willey", "Bille", "Billy", "Billey",
    "Bell", "Bela", "Wile", "Wily", "Wiley", "Wilhelm",
    "Willis", "Zachariah", "Zach", "Zacharias", "Zachare",
    "Zachary", "Zacharey", "Zeke", "Zache", "Zachy",
    "Zachey", "Rye", "Alderick", "Al", "Rich", "Riche",
    "Richy", "Richey", "Alexander", "Alec", "Alex", "Ande",
    "Andy", "Andey", "Ec", "Sande", "Sandy", "Sandey",
    "Alphinias", "Alphus", "Aphinius", "Phineas", "Finnius",
    'Iroh', 'AvatarAang', 'Katarakasar', 'Generalsokrt',
    'Karaktlrt', 'guiltyLocust8', 'DebonairCake4', 'SincereBoars0', 'GutturalCrane9',
    'MadMoth4', 'ForsakenFalcon6', 'SadMoth1', 'SoreCake5', 'GrumpyBuzzard2',
    'CuriousCrane8', 'CynicalBasmati3', 'CruelCardinal9',
    'DecimalRuffs0', 'BoastfulSnipe6', 'BetrayedWidgeon7',];



admin.initializeApp(functions.config().firestore);
const db = admin.firestore();

function shuffleArray(array) {
    for (var i = array.length - 1; i > 0; i--) {

        // Generate random number
        var j = Math.floor(Math.random() * (i + 1));

        var temp = array[i];
        array[i] = array[j];
        array[j] = temp;
    }

    return array;
}

exports.createNewUserMeta = functions.auth.user().onCreate(async (user) => {
    const newUserUid = user.uid;
    const newUserMail = user.email;
    const newUserPassword = "nothing";
    var newUserName = user.displayName;
    const usersRef = db.collection('users').doc(newUserUid);





    const batch = db.batch();

    if (newUserName == null) {
        newUserName = "userdefault"

    }


    let myCurrentDate = new Date();
    //var myCurrentDate = new Date();
    const solutionDate = myCurrentDate.getTime();





    batch.set(usersRef, {
        "user_name": newUserName,
        "user_email": newUserMail,
        "user_password": newUserPassword,
        "user_token": solutionDate + 80000000,
        "user_uid": newUserUid,
        "user_first_verify": false,
        "user_second_verify": false,
        "user_photo": "https://firebasestorage.googleapis.com/v0/b/dbripper-b935d.appspot.com/o/constants%2Fripper_default_profile.png.jpeg?alt=media&token=b79e6ab6-8ea5-4d75-a520-4bb8c3e491e2",
        "user_phone": "nothing",

    });




    await batch.commit();



});
exports.timeTrade1 = functions.firestore.document('transfers/{docNo}').onCreate(async (snap, context) => {

    const transferData = snap.data();

    const recieverUid = transferData.recieverUid;
    const senderUid = transferData.senderUid;
    const transferAmount = transferData.transferAmount;
    const transferDate = transferData.transferDate;


    console.log(recieverUid);
    console.log(senderUid);
    console.log(transferAmount);
    console.log(transferDate);

    const senderUserRef = db.collection('users').doc(senderUid);
    const transferOrdersRef = db.collection('transfer_orders').doc();

    try {

        db.runTransaction(async (t) => {

            var targetSenderUser = await t.get(senderUserRef);

            var targetSenderUserData = targetSenderUser.data();

            console.log(targetSenderUserData.user_token);
            if (targetSenderUserData.user_token > transferAmount) {

                var newTokenAmount = targetSenderUserData.user_token - transferAmount;
                console.log(newTokenAmount);
                t.update(senderUserRef, {
                    "user_token": newTokenAmount
                });

                t.set(transferOrdersRef, {
                    'senderUid': senderUid,
                    'recieverUid': recieverUid,
                    'transferAmount': transferAmount,
                    'transferDate': transferDate

                });

            }


        });

    } catch (error) {
        console.log('Transaction failure:', error);
    }





});
exports.timeTrade2 = functions.firestore.document('transfer_orders/{docNo}').onCreate(async (snap, context) => {

    const transferData = snap.data();

    const recieverUid = transferData.recieverUid;
    const senderUid = transferData.senderUid;
    const transferAmount = transferData.transferAmount;
    const transferDate = transferData.transferDate;
    const orderDocNo = context.params.docNo;


    console.log(recieverUid);
    console.log(senderUid);
    console.log(transferAmount);
    console.log(transferDate);


    const recieverUserRef = db.collection('users').doc(recieverUid);
    const transferBookRef = db.collection('transfer_book').doc();
    const orderRef = db.collection('transfer_orders').doc(orderDocNo);
    try {

        db.runTransaction(async (t) => {

            var targetRecieverUser = await t.get(recieverUserRef);

            var targetRecieverUserData = targetRecieverUser.data();

            console.log(targetRecieverUserData.user_token);

            var newTokenAmount = targetRecieverUserData.user_token + transferAmount;
            console.log(newTokenAmount);
            var senderBookName = await senderUid.substring(0, 6);
            senderBookName = senderBookName + "*****"

            var recieverBookName = await recieverUid.substring(0, 6);
            recieverBookName = recieverBookName + "*****"
            console.log("kk1");
            t.update(recieverUserRef, {
                "user_token": newTokenAmount
            });

            console.log("kk2");

            t.set(transferBookRef, {
                'senderBookName': senderBookName,
                'recieverBookName': recieverBookName,
                'transferAmount': transferAmount,
                'transferDate': transferDate

            });
            console.log("kk3");
            t.delete(orderRef);
            console.log("kk4");


        });

    } catch (error) {
        console.log('Transaction failure:', error);
    }





});
exports.giftRequestPoolChecker = functions.firestore.document('gift_requests/{docNo}').onCreate(async (snap, context) => {

    const requestData = snap.data();

    const giftNo = requestData.gift_no;
    const requestTime = requestData.request_time;
    const requesterLocation = requestData.requester_location;
    const requesterUid = requestData.requester_uid;
    const requestDocNo = context.params.docNo;



    console.log(giftNo);
    console.log(requestTime);
    console.log(requesterLocation);
    console.log(requesterUid);

    const targetGiftRef = db.collection('gifts').doc(giftNo);
    const targetGiftRecievedListRef = db.collection('gifts').doc(giftNo).collection('recieved_list').doc(requesterUid);
    const requestDeleteRef = db.collection('gift_requests').doc(requestDocNo);



    try {

        db.runTransaction(async (t) => {

            var targetGiftFeatures = await t.get(targetGiftRef);
            var targetGiftData = targetGiftFeatures.data();
            console.log(targetGiftData.gift_no);

            if (requestTime < targetGiftData.finish_time) {
                //gift still working
                if (targetGiftData.location_requirement == true) {

                    //need location check
                }
                else {

                    var dateNow = new Date();
                    var dateNowGet = dateNow.getTime();

                    // not need location check
                    t.set(targetGiftRecievedListRef, {
                        'reciever_uid': requesterUid,
                        'gift_value': targetGiftData.gift_value,
                        'recieve_time': dateNowGet,
                        'recieve_location': requesterLocation,
                        'gift_no': giftNo
                    });
                }
            }
            t.delete(requestDeleteRef);
        });

    } catch (error) {
        console.log('Transaction failure:', error);
    }





});
exports.recieveListChecker = functions.firestore.document('gifts/{giftNo}/recieved_list/{requesterUid}').onCreate(async (snap, context) => {

    const recieveData = snap.data();

    const giftValue = recieveData.gift_value;
    const recieverUid = recieveData.reciever_uid;
    const giftNo = recieveData.gift_no;


    console.log(giftValue);
    console.log(recieverUid);


    const recieverRef = db.collection('users').doc(recieverUid);
    const giftStatisticsRef = db.collection('gifts').doc(giftNo).collection('gift_statistics').doc('scan_statistics');

    try {

        db.runTransaction(async (t) => {

            var recieverGetting = await t.get(recieverRef);
            var recieverData = recieverGetting.data();
            console.log(recieverData.user_token);
            var addedToken = giftValue * 86400000;

            var userNewTokenValue = addedToken + recieverData.user_token;
            t.update(recieverRef, {
                'user_token': userNewTokenValue,

            });
        });

    } catch (error) {
        console.log('Transaction failure:', error);
    }


    try {

        db.runTransaction(async (t) => {

            var giftStatisticsGetting = await t.get(giftStatisticsRef);
            var giftStatisticsData = giftStatisticsGetting.data();
            console.log(giftStatisticsData.scan_amount);

            var newScanValue = giftStatisticsData.scan_amount + 1;

            t.update(giftStatisticsRef, {
                'scan_amount': newScanValue,

            });
        });

    } catch (error) {
        console.log('Transaction failure:', error);
    }





});
exports.gameCreate = functions.pubsub.schedule('every 3 minutes').onRun(async (ctx) => {
    console.log(ctx.timestamp);

    // const textFeedItems = await db.collectionGroup('text_feeds').orderBy('like_value', 'desc').limit(2).get();
    const currentDate = new Date();

    var betFinishDate = new Date(currentDate.getTime() + 60 * 1000);
    var rollTime = new Date(currentDate.getTime() + 90 * 1000);
    const newGameDate = new Date(currentDate.getTime() + 180 * 1000);


    const toDate = currentDate.getTime();
    const betFinishToDate = betFinishDate.getTime();
    const rollTimeToDate = rollTime.getTime();
    const newGameDateToDate = newGameDate.getTime();



    const gamesRef = db.collection('games').doc();
    const gamesForUpdate = db.collection('games').doc(gamesRef.id);
    const betPoolRef = db.collection('bet_pool').doc();
    const winnerPoolRef = db.collection('winners').doc(gamesRef.id);

    const gameRefWithNo = db.collection('games').doc(gamesRef.id);

    var betValue = 101 * 86400000;
    const betForRipperRef = db.collection('games').doc(gamesRef.id).collection("players").doc('rr3hfVwLY1gtui0fjN0BCNXMcL62');










    await gamesRef.set({
        'gameNo': gamesRef.id,
        'gameWinner': { playerUid: '-', playerName: '-' },
        'gameTotalBet': 0,
        'gameDate': toDate,
        'gameQr': gamesRef.id,
        'betFinish': false,
        'rollWheel': false,
        'gameFinish': false,
        'playerList': [],
        'betFinishDate': betFinishToDate,
        'rollTime': rollTimeToDate,
        'newGameDate': newGameDateToDate





    });


    await betForRipperRef.set({
        'betAmount': betValue,
        'playerName': "RIPPER",
        'playerPhoto': 'https://firebasestorage.googleapis.com/v0/b/dbripper-b935d.appspot.com/o/constants%2Fripper_default_profile.png.jpeg?alt=media&token=b79e6ab6-8ea5-4d75-a520-4bb8c3e491e2',
        'playerUid': 'CZVnLYJolaWQXnSiuNXuL2PMMz02'




    });





    function addBotDatabase(betAmount, playerName, playerUid) {
        const betForBots = db.collection('bet_pool');
        betForBots.add({
            'betAmount': betAmount,
            'playerName': playerName,
            'playerPhoto': 'https://firebasestorage.googleapis.com/v0/b/dbripper-b935d.appspot.com/o/constants%2Fripper_default_profile.png.jpeg?alt=media&token=b79e6ab6-8ea5-4d75-a520-4bb8c3e491e2',
            'playerUid': playerUid,
            'targetGameNo': gamesRef.id,
            'betDate': currentDate.getTime(),

        });
    }
    await shuffleArray(botNames);


    var botCarpan0 = Math.floor(Math.random() * (5)) + 1;
    var botCarpan = Math.floor(Math.random() * (7)) + 1 * botCarpan0;
    var botBetValue = 86400000;




    await sleep(2 * 1000);
    var bot1Value = Math.floor(Math.random() * (150)) + 1 * botCarpan;
    var bot1TimeValue = bot1Value * botBetValue;

    addBotDatabase(bot1TimeValue, botNames[0], '0ATPaMfkqpV0FOPIzeCKVTxRhog2');

    await sleep(2 * 1000);
    //var bot2Value = Math.floor(Math.random() * (45)) + 1 * botCarpan;
    //var bot2TimeValue = bot2Value * botBetValue;
    //addBotDatabase(bot2TimeValue, botNames[1], '2HfYfL6FhEfdPJkheiROapswI6Q2');

    await sleep(3 * 1000);
    //var bot3Value = Math.floor(Math.random() * (32)) + 1 * botCarpan;
    //var bot3TimeValue = bot3Value * botBetValue;
    //addBotDatabase(bot3TimeValue, botNames[2], '2hDEf4bT8qaFdc787eZ3riZ1xl82');

    await sleep(2 * 1000);
   /* if (rollTimeToDate % 10 == 0) {
        var bot4Value = Math.floor(Math.random() * (133)) + 1 * botCarpan;
        var bot4TimeValue = bot4Value * botBetValue;
        addBotDatabase(bot4TimeValue, botNames[3], '5Hy9qeC92bPtJVcuVerGVNGS1nu1');
    }*/
    await sleep(3 * 1000);

    if (rollTimeToDate % 22 == 0) {
        var bot5Value = Math.floor(Math.random() * (39)) + 1 * botCarpan;
        var bot5TimeValue = bot5Value * botBetValue;
        addBotDatabase(bot5TimeValue, botNames[4], '8i32nWJNyUcT5hZ5f4lkz542dGD2');
    }


    await sleep(3 * 1000);

    if (rollTimeToDate % 33 == 0) {
        var bot6Value = Math.floor(Math.random() * (49)) + 1 * botCarpan;
        var bot6TimeValue = bot6Value * botBetValue;
        addBotDatabase(bot6TimeValue, botNames[5], 'ATf4jdEuijXUpC0mUabY5sP3q3c2');

    }



    await sleep(3 * 1000);
    if (rollTimeToDate % 40 == 0) {
        var bot7Value = Math.floor(Math.random() * (250)) + 1 * botCarpan;
        var bot7TimeValue = bot7Value * botBetValue;
        addBotDatabase(bot7TimeValue, botNames[6], 'AntyoZckMFZ2b74HQ7251wWwiNn2');

    }


    await sleep(2 * 1000);
    if (rollTimeToDate % 50 == 0) {
        var bot8Value = Math.floor(Math.random() * (63)) + 1 * botCarpan;
        var bot8TimeValue = bot8Value * botBetValue;
        addBotDatabase(bot8TimeValue, botNames[7], 'CevxTssggMa6GlAzBSx9j3Tyalk1');


    }



    await sleep(3 * 1000);
  /*  if (rollTimeToDate % 6 == 0) {
        var bot9Value = Math.floor(Math.random() * (84)) + 1 * botCarpan;
        var bot9TimeValue = bot9Value * botBetValue;
        addBotDatabase(bot9TimeValue, botNames[8], 'F4HkslVK5ZNX6wFlGtjTaJSTsHj2');


    }*/



    await sleep(3 * 1000);
    if (rollTimeToDate % 7 == 0) {
        var bot10Value = Math.floor(Math.random() * (162)) + 1 * botCarpan;
        var bot10TimeValue = bot10Value * botBetValue;
        addBotDatabase(bot10TimeValue, botNames[9], 'IPtojs6lt5VS97GQkaFebVFRL6o2');


    }



    await sleep(3 * 1000);
    if (rollTimeToDate % 8 == 0) {

        var bot11Value = Math.floor(Math.random() * (40)) + 1 * botCarpan;
        var bot11TimeValue = bot11Value * botBetValue;
        addBotDatabase(bot11TimeValue, botNames[10], 'O6e9PZH6W9UFNmjDBdDgariWiPQ2');


    }



    await sleep(5 * 1000);
    if (rollTimeToDate % 9 == 0) {
        var bot12Value = Math.floor(Math.random() * (39)) + 1 * botCarpan;
        var bot12TimeValue = bot12Value * botBetValue;
        addBotDatabase(bot12TimeValue, botNames[11], 'TanDqzG4H1RzoCGILjOteZ0NW3s2');


    }



    await sleep(3 * 1000);
    /*if (rollTimeToDate % 10 == 0) {
        var bot13Value = Math.floor(Math.random() * (224)) + 1 * botCarpan;
        var bot13TimeValue = bot13Value * botBetValue;
        addBotDatabase(bot13TimeValue, botNames[12], 'UwZE0Zmz2MMjssciSbeSGHwHInh2');


    }*/



    await sleep(3 * 1000);
    if (rollTimeToDate % 11 == 0) {
        var bot14Value = Math.floor(Math.random() * (30)) + 1 * botCarpan;
        var bot14TimeValue = bot14Value * botBetValue;
        addBotDatabase(bot14TimeValue, botNames[13], 'VJqv5dT0s6TU6gzKBVKOORbUW152');


    }



    await sleep(3 * 1000);
   /* if (rollTimeToDate % 12 == 0) {
        var bot15Value = Math.floor(Math.random() * (141)) + 1 * botCarpan;
        var bot15TimeValue = bot15Value * botBetValue;
        addBotDatabase(bot15TimeValue, botNames[14], 'XE2F4Vv7YXNaqc8Xu9XAJQccurB3');


    }*/



    await sleep(2 * 1000);
    if (rollTimeToDate % 30 == 0) {
        var bot16Value = Math.floor(Math.random() * (33)) + 1 * botCarpan;
        var bot16TimeValue = bot16Value * botBetValue;
        addBotDatabase(bot16TimeValue, botNames[15], 'aPPc6WGPWHgQjx4gBSpmVqAtm172');


    }



    await sleep(2 * 1000);
    if (rollTimeToDate % 40 == 0) {
        var bot17Value = Math.floor(Math.random() * (425)) + 1 * botCarpan;
        var bot17TimeValue = bot17Value * botBetValue;
        addBotDatabase(bot17TimeValue, botNames[16], 'bDTO9YlKX7Nkl9hGmlcLVUcy2mR2');


    }



    await sleep(3 * 1000);
    if (rollTimeToDate % 44 == 0) {
        var bot18Value = Math.floor(Math.random() * (28)) + 1 * botCarpan;
        var bot18TimeValue = bot18Value * botBetValue;
        addBotDatabase(bot18TimeValue, botNames[17], 'dcGEOHiieIU4W8lFmlr5fSK2De53');


    }



    await sleep(2 * 1000);
    if (rollTimeToDate % 50 == 0) {
        var bot19Value = Math.floor(Math.random() * (46)) + 1 * botCarpan;
        var bot19TimeValue = bot19Value * botBetValue;
        addBotDatabase(bot19TimeValue, botNames[18], 'eYEvibNXyCOKCZksvrqQEejUAMS2');


    }



    await sleep(2 * 1000);
  /*  if (rollTimeToDate % 4 == 0) {
        var bot20Value = Math.floor(Math.random() * (262)) + 1 * botCarpan;
        var bot20TimeValue = bot20Value * botBetValue;
        addBotDatabase(bot20TimeValue, botNames[19], 'fAEP7PEl9lhKQmt03J3MIIgNLPr2');


    }*/



    await sleep(2 * 1000);
    if (rollTimeToDate % 6 == 0) {
        var bot21Value = Math.floor(Math.random() * (156)) + 1 * botCarpan;
        var bot21TimeValue = bot21Value * botBetValue;
        addBotDatabase(bot21TimeValue, botNames[20], 'l85DFUyNRdbplRzz0Hztm6xo0Vp2');


    }



    await sleep(2 * 1000);
    /*if (rollTimeToDate % 2 == 0) {

        var bot22Value = Math.floor(Math.random() * (145)) + 1 * botCarpan;
        var bot22TimeValue = bot22Value * botBetValue;
        addBotDatabase(bot22TimeValue, botNames[21], 'tXGhGpIMaUfcsSl8HbPXuLYEgJr2');


    }*/




    await sleep(2 * 1000);
    /*if (rollTimeToDate % 4 == 0) {
        var bot23Value = Math.floor(Math.random() * (244)) + 1 * botCarpan;
        var bot23TimeValue = bot23Value * botBetValue;
        addBotDatabase(bot23TimeValue, botNames[22], 'xVufzboy72Wic1aB2NDMvTWvBfD2');

    }*/






    await gamesForUpdate.update({

        'betFinish': true
    });

    await sleep(30 * 1000);
    const playersGet = await gamesForUpdate.collection('players').get();

    const playersData = playersGet.docs;

    var winnerPool = [];

    var betTotals = 0;



    for (const key in playersData) {
        if (Object.hasOwnProperty.call(playersData, key)) {
            const element = playersData[key];
            var betCycleValue = element.data().betAmount / 86400000;


            betTotals = betTotals + betCycleValue;



        }
    }

    for (const key in playersData) {
        if (Object.hasOwnProperty.call(playersData, key)) {
            const element = playersData[key];
            var betCycleValue = element.data().betAmount / 86400000;
            var thisPercent = betCycleValue / (betTotals / 100);
            var loopValue = thisPercent * 10 >= 1 ? thisPercent * 10 : 1;

            for (let index = 1; index <= loopValue; index++) {

                var newElement = {
                    playerUid: element.data().playerUid,
                    playerName: element.data().playerName
                }
                winnerPool.push(newElement);


            }





        }
    }






    //çekilişte hata var yeni sistem geliştir
    await shuffleArray(winnerPool);


    var winnerNumber = Math.floor(winnerPool.length - 1);

    var winnerPlayer = winnerPool[winnerNumber];
    await gamesForUpdate.update({ "gameWinner": winnerPlayer });


    try {

        console.log('girdi1');

        db.runTransaction(async (t) => {

            var gameGetting = await t.get(gameRefWithNo);
            var gameData = gameGetting.data();

            t.set(winnerPoolRef, {

                'betAmount': gameData.gameTotalBet,
                'gameNo': gamesRef.id,
                'winDate': toDate,
                'winnerUid': winnerPlayer.playerUid,
            });




        });

    } catch (error) {

        console.log('Transaction failure:', error);
    }


    await sleep(30 * 1000);

    const gameNewGetting = await gamesForUpdate.get();
    const gameNewData = gameNewGetting.data();

    if (gameNewData.gameTotalBet != 0) {
        await gamesForUpdate.update({
            'rollWheel': true
        });

    }
    else {
        await gamesForUpdate.update({

            'gameFinish': true
        });
    }

});
exports.betPoolChecker = functions.firestore.document('bet_pool/{betNo}').onCreate(async (snap, context) => {

    const betData = snap.data();

    const targetGameNo = betData.targetGameNo;
    const playerUid = betData.playerUid;
    const betAmount = betData.betAmount;
    const playerPhoto = betData.playerPhoto;
    const playerName = betData.playerName;
    const betDate = betData.betDate;
    const betNo = context.params.betNo;




    const playerRef = db.collection('users').doc(playerUid);
    const approvedRef = db.collection('approved_pool').doc();
    const betRef = db.collection('bet_pool').doc(betNo);




    try {

        console.log('girdi1');

        db.runTransaction(async (t) => {

            var playerGetting = await t.get(playerRef);

            //burada token miktarı hespalamayı yap 
            var playerData = playerGetting.data();


            var controlToken = betDate + betAmount;

            var userToken = playerData.user_token;


            console.log('betdate');
            console.log(betDate);
            console.log('betAmount');
            console.log(betAmount);

            console.log('user token ');
            console.log(userToken);
            console.log('control token');
            console.log(controlToken);
            if (userToken > controlToken) {

                t.update(playerRef, {
                    'user_token': userToken - betAmount
                });

                t.set(approvedRef, {
                    'betAmount': betAmount,
                    'playerName': playerName,
                    'playerPhoto': playerPhoto,
                    'playerUid': playerUid,
                    'targetGameNo': targetGameNo
                });

                //evet kişinin tokenı yetiyor
                // tokenControlBool = true;
            }
            else {
                t.delete(betRef);

            }


        });

    } catch (error) {


        console.log('Transaction failure:', error);
    }

    /*
        try {
    
            db.runTransaction(async (t) => {
                console.log('girdi2');
                var gameGetting = await t.get(gameRef);
                var gameData = gameGetting.data();
                console.log(gameData.betFinish);
                console.log(gameData.gameFinish);
                console.log(gameData.rollWheel);
                console.log(tokenControlBool);
    
    
                if (gameData.rollWheel == false && tokenControlBool == true) {
    
                    console.log("girdii");
    
                    t.set(gameBetRef, {
                        'betAmount': betAmount,
                        'playerName': playerName,
                        'playerPhoto': playerPhoto,
                        'playerUid': playerUid,
    
                    });
    
    
                    t.update(playerRef, {
    
                        'user_token': userToken - betAmount
                    });
    
    
    
    
    
    
    
    
                }
    
    
    
    
    
    
    
    
            });
            isBetComplete = true;
    
        } catch (error) {
            isBetComplete = false;
            console.log('Transaction failure:', error);
        }
    
    
    
    
        try {
            console.log('girdi3');
    
            db.runTransaction(async (t) => {
    
                var gameGetting = await t.get(gameRef);
    
                //burada token miktarı hespalamayı yap 
                var gameData = gameGetting.data();
    
                var gamePlayerList = gameData.playerList;
                await gamePlayerList.push(playerName);
    
                var gameNewBetValue = gameData.gameTotalBet + betAmount;
                if (isBetComplete) {
                    console.log('comp');
    
                    t.update(gameRef, {
    
                        'gameTotalBet': gameNewBetValue,
                        'playerList': gamePlayerList,
                    })
    
                }
    
    
    
    
    
    
    
            });
    
        } catch (error) {
    
            console.log('Transaction failure:', error);
        }
    */






});
exports.approvedPoolChecker = functions.firestore.document('approved_pool/{approvedNo}').onCreate(async (snap, context) => {


    const betData = snap.data();

    const targetGameNo = betData.targetGameNo;
    const playerUid = betData.playerUid;
    const betAmount = betData.betAmount;
    const playerPhoto = betData.playerPhoto;
    const playerName = betData.playerName;
    const approvedDocNo = context.params.approvedNo;



    const gameRef = db.collection('games').doc(targetGameNo);
    const refundRef = db.collection('refund_pool').doc();
    const approvedRef = db.collection('approved_pool').doc(approvedDocNo);

    const gameSubCollectionRef = db.collection('games').doc(targetGameNo).collection('players').doc(playerUid);


    try {



        db.runTransaction(async (t) => {

            var gameGetting = await t.get(gameRef);

            //burada token miktarı hespalamayı yap 
            var gameData = gameGetting.data();


            if (gameData.rollWheel == false) {

                t.set(gameSubCollectionRef, {
                    'betAmount': betAmount,
                    'playerName': playerName,
                    'playerPhoto': playerPhoto,
                    'playerUid': playerUid,

                });



            }
            else {

                t.set(refundRef, {
                    'betAmount': betAmount,
                    'playerUid': playerUid

                });

                t.delete(approvedRef);

            }


        });

    } catch (error) {

        console.log('Transaction failure:', error);
    }








});
exports.gameSubCollectionChecker = functions.firestore.document('games/{gameNo}/players/{playerUid}').onCreate(async (snap, context) => {


    const betData = snap.data();


    const playerUid = betData.playerUid;
    const betAmount = betData.betAmount;
    const playerPhoto = betData.playerPhoto;
    const playerName = betData.playerName;

    const gameNo = context.params.gameNo;




    const gameRef = db.collection('games').doc(gameNo);


    try {



        db.runTransaction(async (t) => {

            var gameGetting = await t.get(gameRef);

            //burada token miktarı hespalamayı yap 
            var gameData = gameGetting.data();


            var gamePlayerList = gameData.playerList;
            await gamePlayerList.push(playerName);

            var gameNewBetValue = gameData.gameTotalBet + betAmount;



            t.update(gameRef, {

                'gameTotalBet': gameNewBetValue,
                'playerList': gamePlayerList,
            })




        });

    } catch (error) {

        console.log('Transaction failure:', error);
    }








});
exports.refundPoolChecker = functions.firestore.document('refund_pools/{refundNo}').onCreate(async (snap, context) => {


    const refundData = snap.data();


    const playerUid = refundData.playerUid;
    const refundAmount = refundData.refundAmount;





    const playerRef = db.collection('users').doc(playerUid);


    try {



        db.runTransaction(async (t) => {

            var playerGetting = await t.get(playerRef);

            //burada token miktarı hespalamayı yap 
            var playerData = playerGetting.data();




            var newUserToken = playerData.user_token + refundAmount;



            t.update(playerRef, {

                'user_token': newUserToken
            })




        });

    } catch (error) {

        console.log('Transaction failure:', error);
    }








});
exports.winnerPoolChecker = functions.firestore.document('winners/{winNo}').onCreate(async (snap, context) => {

    const winData = snap.data();

    const gameNo = winData.gameNo;
    const winnerUid = winData.winnerUid;
    const betAmount = winData.betAmount;


    const winnerPoolRef = db.collection('winners').doc(gameNo);
    const winnerPlayerRef = db.collection('users').doc(winnerUid);


    try {
        console.log('girdi3');

        db.runTransaction(async (t) => {

            var userGetting = await t.get(winnerPlayerRef);

            //burada token miktarı hespalamayı yap 
            var userData = userGetting.data();


            var newTokenAmount = userData.user_token + betAmount;


            t.update(winnerPlayerRef, {
                'user_token': newTokenAmount
            });









        });

        await winnerPoolRef.delete();

    } catch (error) {

        console.log('Transaction failure:', error);
    }
    const gamesForUpdate = db.collection('games').doc(gameNo);
    //const gamesArchiveRef = db.collection('games_archive').doc(gameNo);



    try {

        console.log('girdi1');

        db.runTransaction(async (t) => {

            var gameGetting = await t.get(gamesForUpdate);
            var gameData = gameGetting.data();

            t.set(gamesArchiveRef, {

                'gameNo': gameData.gameNo,
                'gameWinner': gameData.gameWinner,
                'gameTotalBet': gameData.gameTotalBet,
                'gameDate': gameData.gameDate,
                'gameQr': gameData.gameQr,
                'betFinish': gameData.betFinish,
                'rollWheel': gameData.rollWheel,
                'gameFinish': gameData.gameFinish,
                'playerList': gameData.playerList,

            });




        });

    } catch (error) {

        console.log('Transaction failure:', error);
    }


});
exports.totalYearStatsUpdate = functions.pubsub.schedule('every 10 minutes').onRun(async (ctx) => {
    console.log(ctx.timestamp);

    const currentDate = new Date();
    const milliGet = currentDate.getTime();

    const usersRef = db.collection('users');
    const settingsRef = db.collection('settings').doc('stats');

    const docSnapshot = await usersRef.get();


    var totalMilliseconds = 0;


    if (docSnapshot.empty) {
        console.log('no matching documents');
        return;

    }
    docSnapshot.forEach(doc => {
        console.log(doc.id, '=>', doc.data());
        var nowLast = doc.data().user_token - milliGet;



        if (nowLast > 0 && doc.data().user_uid != "CZVnLYJolaWQXnSiuNXuL2PMMz02") {
            totalMilliseconds = totalMilliseconds + nowLast;

        }

    });

    var totalYear = totalMilliseconds / 31622400000;



    await settingsRef.update({
        'total_year': totalYear
    });










});
exports.newDailyBonusUpdate = functions.pubsub.schedule('every 24 hours').onRun(async (ctx) => {
    console.log(ctx.timestamp);

    const currentDate = new Date();
    var tomorrow = new Date();
    tomorrow.setDate(currentDate.getDate() + 1);



    var giftValue = (Math.floor(200)) + 50;
    const newGiftRef = db.collection('gifts').doc();
    const statisticRef = db.collection('gifts').doc(newGiftRef.id).collection('gift_statistics').doc('scan_statistics');
    const recieverRef = db.collection('gifts').doc(newGiftRef.id).collection('recieved_list');
    const giftSettingRef = db.collection('settings').doc('gift_settings');

    const giftSettingGetting = await giftSettingRef.get();

    const giftSettingData = giftSettingGetting.data();



    await newGiftRef.set({
        'finish_time': tomorrow,
        'gift_area': giftSettingData.gift_area,
        'gift_no': newGiftRef.id,
        'gift_value': giftValue,
        'location_requirement': giftSettingData.location_requirement
    });
    await statisticRef.set({ 'scan_amount': 0 });

    await recieverRef.add({
        'gift_no': newGiftRef.id,
        'gift_value': giftValue,
        'recieve_location': giftSettingData.gift_area,
        'recieve_time': 1656855074036,
        'reciever_uid': 'abidikkubidik'
    });









});
exports.deleteAccountPoolChecker = functions.firestore.document('delete_account_requests/{userUid}').onCreate(async (snap, context) => {

    const deleteData = snap.data();

    const userUid = deleteData.user_uid;

    const userRef = db.collection('users').doc(userUid);
    const deletedAccountRef = db.collection('deleted_account').doc(userUid);


    userRefData = await userRef.get();




    try {
        await deletedAccountRef.set({
            'user_email': userRefData.data().user_email,
            'user_first_verify': userRefData.data().user_first_verify,
            'user_name': userRefData.data().user_name,
            'user_password': userRefData.data().user_password,
            'user_phone': userRefData.data().user_phone,
            'user_photo': userRefData.data().user_photo,
            'user_second_verify': userRefData.data().user_second_verify,
            'user_token': userRefData.data().user_token,
            'user_uid': userRefData.data().user_uid
        });
        await userRef.delete();
        await admin.auth().updateUser(userUid, { disabled: true });

    }
    catch (err) {
        console.error(err);
    }









});

exports.leaderBoardUpdate = functions.pubsub.schedule('every 60 minutes').onRun(async (ctx) => {
    console.log(ctx.timestamp);

    const currentDate = new Date();
    const milliGet = currentDate.getTime();

    const usersRef = db.collection('users').orderBy('user_token', 'desc').limit(11);
    const settingsRef = db.collection('settings').doc('leaderboard');

    const docSnapshot = await usersRef.get();



    var leaderBoardTop = [];

    if (docSnapshot.empty) {
        console.log('no matching documents');
        return;

    }
    docSnapshot.forEach(doc => {
        console.log(doc.id, '=>', doc.data());
        if (doc.data().user_uid != "CZVnLYJolaWQXnSiuNXuL2PMMz02") {
            var nowLast = (doc.data().user_token - milliGet) / 31622400000;
            var topElement = {
                'user_name': doc.data().user_name,
                'user_year': nowLast,
            }
            leaderBoardTop.push(topElement);
        }
    });
    await settingsRef.update({
        'top_list': leaderBoardTop
    });










});
/*exports.gameArchiveChecker = functions.firestore.document('games_archive/{gameNo}').onCreate(async (snap, context) => {



    const gameData = snap.data();

    const gamesForDelete = db.collection('games').doc(gameData.gameNo);
    const gamesSubCollectionDelete = db.collection('games').doc(gameData.gameNo).collection('players').docs;



    await sleep(100 * 1000);
    await gamesSubCollectionDelete.delete();
    await gamesForDelete.delete();




});*/

//recieved_list checker ekle girenleri kontrol et yeni create edildiyse zaten gönderiim yapar
