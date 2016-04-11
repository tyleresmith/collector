*****Collector*****
Making tracking your collections easy (think pokedex but for whatever)


User has many collections
Collection belongs to an user, has many items
Items belong to a collection



User has username, email, password, timestamp
Collection has name, description, user_id, timestamp
Item has name, picture, description, timestamp, collected status, collection_id


Collections should not be able to be created/edited without a name or descripion
Items should not be able to be created/edited without a name. Description and picture should be optional

Items should be able to be toggled between collected/missing (true/false)


TODO
Create break for sign up field (labels dont align)

Input error messages