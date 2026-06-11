const weights = Array.from({ length: 12 }, (_, index) => 2 ** (11 - index));
const selected = new Set();

const words = window.BIP39_ENGLISH_WORDS || [];
const dotGrid = document.querySelector("#dotGrid");
const indexValue = document.querySelector("#indexValue");
const wordOutput = document.querySelector("#wordOutput");
const clearButton = document.querySelector("#clearButton");
const copyButton = document.querySelector("#copyButton");
const wordInput = document.querySelector("#wordInput");
const message = document.querySelector("#message");

function getIndex() {
  return [...selected].reduce((sum, weight) => sum + weight, 0);
}

function getCurrentWord() {
  const index = getIndex();
  return index >= 1 && index <= words.length ? words[index - 1] : "";
}

function setMessage(text, isError = false) {
  message.textContent = text;
  message.classList.toggle("error", isError);
}

function render() {
  const index = getIndex();
  const word = getCurrentWord();

  indexValue.textContent = String(index);
  wordOutput.textContent = word || (index > words.length ? "Outside BIP39 range" : "Select at least one dot");
  copyButton.disabled = !word;

  document.querySelectorAll(".dot").forEach((button) => {
    const weight = Number(button.dataset.weight);
    button.setAttribute("aria-pressed", String(selected.has(weight)));
  });
}

function setIndex(index) {
  selected.clear();
  weights.forEach((weight) => {
    if ((index & weight) === weight) selected.add(weight);
  });
  render();
}

function makeDot(weight) {
  const button = document.createElement("button");
  button.type = "button";
  button.className = "dot";
  button.dataset.weight = String(weight);
  button.setAttribute("aria-pressed", "false");
  button.setAttribute("aria-label", `Toggle weight ${weight}`);

  const label = document.createElement("span");
  label.className = "weight";
  label.textContent = String(weight);
  button.append(label);

  button.addEventListener("click", () => {
    if (selected.has(weight)) {
      selected.delete(weight);
    } else {
      selected.add(weight);
    }
    wordInput.value = "";
    setMessage("");
    render();
  });

  return button;
}

weights.forEach((weight) => dotGrid.append(makeDot(weight)));

clearButton.addEventListener("click", () => {
  selected.clear();
  wordInput.value = "";
  setMessage("");
  render();
});

copyButton.addEventListener("click", async () => {
  const word = getCurrentWord();
  if (!word) return;

  try {
    await navigator.clipboard.writeText(word);
    setMessage(`Copied: ${word}`);
  } catch {
    setMessage(`Current word: ${word}`);
  }
});

wordInput.addEventListener("input", () => {
  const value = wordInput.value.trim().toLowerCase();
  if (!value) {
    setMessage("");
    return;
  }

  const index = words.indexOf(value) + 1;
  if (index === 0) {
    setMessage("This word is not in the BIP39 English wordlist.", true);
    return;
  }

  setIndex(index);
  setMessage(`${value} is word #${index}.`);
});

render();
