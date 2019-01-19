import { Auth } from 'aws-amplify';
import { AmplifyService } from 'aws-amplify-angular';
import { Injectable } from '@angular/core';
import { CookieService } from 'ngx-cookie-service';

@Injectable()
export class AuthService {
    constructor(
      private amplify: AmplifyService,
      private cookie: CookieService,
    ) {}

    authState: string;

    init() {
    this.amplify.authStateChange$.subscribe(authState=> {
        this.authState = authState.state;
    })
}

    login(username: string, password: string){
        Auth.signIn(username,password)
        .then(user=>{
            this.cookie.set('username',user['username']);
            this.cookie.set(
                'auth',
                user['signInUserSession']['accessToken']['jwtToken']

            );
            Auth.currentAuthenticatedUser().then(user=>{

            this.cookie.set('username',user.username);
            this.cookie.set('firstName',user.attributes.firstName);
            this.cookie.set('lastName',user.attributes.lastName);
            this.cookie.set('email',user.attributes.email);
        })
        .catch(err => console.log(err));
    })
}

    logout(){
        Auth.signOut()
        .then(data=>{
            this.cookie.delete('auth'),
            this.cookie.delete('username'),
            this.cookie.delete('firstName'),
            this.cookie.delete('lastName'),
            this.cookie.delete('email')
        })
        .catch(err=>console.log(err));
}


    createAccount(
        username: string,
        password: string,
        email: string,
        firstName: string,
        lastName: string,
        phoneNumber: string,
        birthDate: string,

    ){
        Auth.signUp({
            username: username,
            password: password,
            attributes:{
                email: email,
                phoneNumber: phoneNumber,
                firstName: firstName,
                lastName: lastName,
                birthDate: birthDate
            },
            validationData: []
        })
    }
}