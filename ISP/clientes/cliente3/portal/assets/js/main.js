// =======================================
// HEADER COM SOMBRA AO ROLAR
// =======================================

window.addEventListener("scroll", () => {

    const header = document.querySelector("header");

    if(window.scrollY > 50){

        header.style.boxShadow = "0 5px 20px rgba(0,0,0,.15)";

    }
    else{

        header.style.boxShadow = "0 2px 10px rgba(0,0,0,.15)";

    }

});

// =======================================
// BOTÃO VOLTAR AO TOPO
// =======================================

const topButton = document.createElement("button");

topButton.innerHTML = "↑";

topButton.id = "backToTop";

document.body.appendChild(topButton);

topButton.style.position = "fixed";
topButton.style.bottom = "30px";
topButton.style.right = "30px";
topButton.style.width = "50px";
topButton.style.height = "50px";
topButton.style.borderRadius = "50%";
topButton.style.border = "none";
topButton.style.background = "#2563eb";
topButton.style.color = "#fff";
topButton.style.fontSize = "22px";
topButton.style.cursor = "pointer";
topButton.style.display = "none";
topButton.style.zIndex = "999";
topButton.style.boxShadow = "0 5px 20px rgba(0,0,0,.2)";
topButton.style.transition = ".3s";

window.addEventListener("scroll", () => {

    if(window.scrollY > 300){

        topButton.style.display = "block";

    }
    else{

        topButton.style.display = "none";

    }

});

topButton.addEventListener("click", () => {

    window.scrollTo({

        top:0,
        behavior:"smooth"

    });

});

// =======================================
// ANIMAÇÃO DOS CARDS
// =======================================

const cards = document.querySelectorAll(

    ".service-card, .advantage, .contact-item"

);

cards.forEach(card => {

    card.addEventListener("mouseenter", () => {

        card.style.transform = "translateY(-10px)";

    });

    card.addEventListener("mouseleave", () => {

        card.style.transform = "translateY(0)";

    });

});

// =======================================
// ANIMAÇÃO DE ENTRADA
// =======================================

const observer = new IntersectionObserver(entries => {

    entries.forEach(entry => {

        if(entry.isIntersecting){

            entry.target.style.opacity = "1";
            entry.target.style.transform = "translateY(0px)";

        }

    });

}, {

    threshold:0.1

});

const sections = document.querySelectorAll(

    "section, .service-card, .advantage, .contact-item"

);

sections.forEach(section => {

    section.style.opacity = "0";
    section.style.transform = "translateY(40px)";
    section.style.transition = ".8s";

    observer.observe(section);

});

// =======================================
// BOTÕES
// =======================================

const buttons = document.querySelectorAll(

    ".btn-primary, .btn-client"

);

buttons.forEach(button => {

    button.addEventListener("mouseenter", () => {

        button.style.transform = "translateY(-3px)";

    });

    button.addEventListener("mouseleave", () => {

        button.style.transform = "translateY(0px)";

    });

});

// =======================================
// DESTACAR MENU ATIVO
// =======================================

const currentPage = location.pathname.split("/").pop();

document.querySelectorAll(".nav-links a").forEach(link => {

    const href = link.getAttribute("href");

    if(href === currentPage){

        link.style.color = "#60a5fa";
        link.style.fontWeight = "bold";

    }

});

// =======================================
// EFEITO DE DIGITAÇÃO NO HERO
// =======================================

const title = document.querySelector(".hero h1");

if(title){

    const text = title.innerHTML;

    title.innerHTML = "";

    let i = 0;

    function typing(){

        if(i < text.length){

            title.innerHTML += text.charAt(i);

            i++;

            setTimeout(typing,40);

        }

    }

    typing();

}

// =======================================
// MENSAGEM DE BOAS-VINDAS
// =======================================

console.log("Portal Cliente 3 carregado com sucesso.");

// =======================================
// ANO AUTOMÁTICO NO FOOTER
// =======================================

const footer = document.querySelector(".footer-bottom p");

if(footer){

    footer.innerHTML =

    `© ${new Date().getFullYear()} Cliente 3. Todos os direitos reservados.`;

}