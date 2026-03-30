document.addEventListener("turbo:load", () => {
  // 投稿フォームの星評価（入力用）
  const elem = document.querySelector("#post_raty");
  if (!elem) return;

  new Raty(elem, {
    scoreName: "book[score]"
  }).init();
});