document.addEventListener("turbolinks:load", () => {
  const reward = document.querySelector("#reward");
  if (reward) {
    reward.addEventListener("click", (event) => {
      if (event.target.classList.contains("add-reward-link")) {
        event.preventDefault();
        event.target.classList.add("hidden");

        reward.querySelector(".reward_fields").classList.toggle("hidden");
      }
      if (event.target.classList.contains("remove-reward-link")) {
        event.preventDefault();
        reward.querySelector(".reward_fields").classList.toggle("hidden");
        reward.querySelector(".add-reward-link").classList.toggle("hidden");
        reward.querySelectorAll(".reward_fields input").forEach((elem) => {
          elem.value = "";
        });
      }
    });
  }
});
