// =========================
// NAVBAR SCROLL
// =========================

window.addEventListener("scroll", () => {

    const navbar = document.querySelector(".navbar");

    if(window.scrollY > 50){
        navbar.style.background = "#0b1220";
        navbar.style.boxShadow = "0 5px 20px rgba(0,0,0,.3)";
    }else{
        navbar.style.background = "#111827";
        navbar.style.boxShadow = "none";
    }

});

// =========================
// MENU ATIVO
// =========================

const currentPage =
window.location.pathname.split("/").pop();

document.querySelectorAll(".nav-links a")
.forEach(link => {

    const href =
    link.getAttribute("href").split("/").pop();

    if(href === currentPage){

        link.style.color = "#00ff88";
        link.style.fontWeight = "700";

    }

});

// =========================
// ANIMAÇÃO AO APARECER
// =========================

const observer = new IntersectionObserver(entries => {

    entries.forEach(entry => {

        if(entry.isIntersecting){

            entry.target.classList.add("show");

        }

    });

},{
    threshold:0.15
});

document.querySelectorAll(
    ".service-card, .plan-card, .advantage, .info-card, .feature, .status-card"
).forEach(el => {

    el.classList.add("hidden");

    observer.observe(el);

});

// =========================
// CONTADOR ANIMADO
// =========================

const counters =
document.querySelectorAll(".stat-item h2");

counters.forEach(counter => {

    const text = counter.innerText;

    const target =
    parseInt(text.replace(/\D/g,""));

    if(!target) return;

    let current = 0;

    const increment = target / 80;

    const updateCounter = () => {

        current += increment;

        if(current < target){

            counter.innerText =
            Math.floor(current) + "+";

            requestAnimationFrame(updateCounter);

        }else{

            counter.innerText = text;

        }

    };

    updateCounter();

});

// =========================
// BOTÃO VOLTAR AO TOPO
// =========================

const topButton =
document.createElement("button");

topButton.innerHTML = "↑";

topButton.id = "backToTop";

document.body.appendChild(topButton);

window.addEventListener("scroll", () => {

    if(window.scrollY > 400){

        topButton.classList.add("show-top");

    }else{

        topButton.classList.remove("show-top");

    }

});

topButton.addEventListener("click", () => {

    window.scrollTo({
        top:0,
        behavior:"smooth"
    });

});