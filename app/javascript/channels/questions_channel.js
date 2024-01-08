import consumer from "./consumer";

consumer.subscriptions.create("QuestionsChannel", {
  connected() {
    // let data = { text: "hello" };
    // this.perform("echo", data);
    this.perform("follow");
  },

  disconnected() {
    console.log("QuestionsChannel disconnected!");
  },

  received(data) {
    const tableBody = document.querySelector("tbody");
    const newRow = document.createElement("tr");
    newRow.innerHTML = data;
    tableBody.insertAdjacentHTML("beforeend", newRow.outerHTML);
  },
});
