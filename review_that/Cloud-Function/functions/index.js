const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

exports.cafeNotification = functions.database.ref('notification/Cafe/most rated').onUpdate(evt => {
    const payload = {
        notification:{
            title : 'Cafe',
            body : 'There is a new top rated Cafe\n check it now!',
            badge : '1',
            sound : 'default'
        }
    };

    return admin.database().ref('Categories/Cafe/tokens').once('value').then(allToken => {
        if(allToken.val()){
            console.log('token available');
            const token = Object.keys(allToken.val());
            return admin.messaging().sendToDevice(token,payload);
        }else{
            console.log('No token available');
        }
    });
});
exports.medicalNotification = functions.database.ref('notification/Medical/most rated').onUpdate(evt => {
    const payload = {
        notification:{
            title : 'Medical',
            body : 'There is a new top rated place in Medical Category\n check it now!',
            badge : '1',
            sound : 'default'
        }
    };

    return admin.database().ref('Categories/Medical/tokens').once('value').then(allToken => {
        if(allToken.val()){
            console.log('token available');
            const token = Object.keys(allToken.val());
            return admin.messaging().sendToDevice(token,payload);
        }else{
            console.log('No token available');
        }
    });
});
exports.RestaurantNotification = functions.database.ref('notification/Restaurabt/most rated').onUpdate(evt => {
    const payload = {
        notification:{
            title : 'Restaurant',
            body : 'There is a new top rated Restaurant\n check it now!',
            badge : '1',
            sound : 'default'
        }
    };

    return admin.database().ref('Categories/Restaurant/tokens').once('value').then(allToken => {
        if(allToken.val()){
            console.log('token available');
            const token = Object.keys(allToken.val());
            return admin.messaging().sendToDevice(token,payload);
        }else{
            console.log('No token available');
        }
    });
});
exports.hotelsNotification = functions.database.ref('notification/Hotels/most rated').onUpdate(evt => {
    const payload = {
        notification:{
            title : 'Hotel',
            body : 'There is a new top rated Hotel\n check it now!',
            badge : '1',
            sound : 'default'
        }
    };

    return admin.database().ref('Categories/Hotels/tokens').once('value').then(allToken => {
        if(allToken.val()){
            console.log('token available');
            const token = Object.keys(allToken.val());
            return admin.messaging().sendToDevice(token,payload);
        }else{
            console.log('No token available');
        }
    });
});
exports.StoresNotification = functions.database.ref('notification/Stores/most rated').onUpdate(evt => {
    const payload = {
        notification:{
            title : 'Stores',
            body : 'There is a new top rated Store\n check it now!',
            badge : '1',
            sound : 'default'
        }
    };

    return admin.database().ref('Categories/Stores/tokens').once('value').then(allToken => {
        if(allToken.val()){
            console.log('token available');
            const token = Object.keys(allToken.val());
            return admin.messaging().sendToDevice(token,payload);
        }else{
            console.log('No token available');
        }
    });
});
exports.shoppingNoification = functions.database.ref('notification/Shopping/most rated').onUpdate(evt => {
    const payload = {
        notification:{
            title : 'Shopping',
            body : 'There is a new top rated shopping Place\n check it now!',
            badge : '1',
            sound : 'default'
        }
    };

    return admin.database().ref('Categories/Shopping/tokens').once('value').then(allToken => {
        if(allToken.val()){
            console.log('token available');
            const token = Object.keys(allToken.val());
            return admin.messaging().sendToDevice(token,payload);
        }else{
            console.log('No token available');
        }
    });
});
