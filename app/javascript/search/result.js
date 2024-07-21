document.addEventListener("turbolinks:load", () => {
  const searchContainer = document.querySelector(".search-container");
  searchContainer.addEventListener("ajax:success", (event) => {
    let result = event.detail[0];
    document.querySelector(".search-result").innerHTML = "";
    document.querySelector(".search-result").innerHTML = result.body.innerHTML;
  });
});
