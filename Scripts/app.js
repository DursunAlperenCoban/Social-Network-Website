const close_btn=document.querySelector("#close-btn");
const sign_up_btn=document.querySelector("#sign-up-btn");
const container = document.querySelector(".sign-up-container");
sign_up_btn.addEventListener('click',()=>{
    container.classList.add("sign-up-mode");
});

close_btn.addEventListener('click',()=>{
    container.classList.remove("sign-up-mode");
});




var check = function() {
       if (document.getElementById('password').value ==
           document.getElementById('confirm_password').value && document.getElementById('password').value.length > 5) {
           document.getElementById('confirm_password').style.color = 'green';
           
           document.getElementById('password').style.color = 'green';
           document.getElementById('register-btn').disabled = false;
          
        } else {
            document.getElementById('confirm_password').style.color = 'red';
           document.getElementById('password').style.color = 'red';
           
           document.getElementById('register-btn').disabled = true;

        }
}
var fname = function () {
    var name = document.getElementById('rFullname').value;
    if (name.length > 6 && name.search(' ')>0) {
        document.getElementById('rFullname').style.color = 'green';
    }
    else {
        document.getElementById('rFullname').style.color = 'red';
        document.getElementById('register-btn').disabled = true;
    }
}
var chkBirth = function () {
    var present = new Date;
    var date = new Date(document.getElementById('rBirth').value)

    
    if (date < present) {
        console.log("true");
        document.getElementById('rBirth').style.color = 'green';
    }
    else {

        document.getElementById('rBirth').style.color = 'red';
        document.getElementById('register-btn').disabled = true;
        
        var msg = alertify.error('Birthdate cannot be greater than present', 3, function () { clearInterval(interval); });
        var interval = setInterval(function () {
            msg.setContent('Birthdate cannot be greater than present');
        }, 3000);
    }
}


