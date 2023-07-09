import express from 'express';

const app = express()
const port = 3000

app.get('/', (req, res) => {
  res.send('Hello World!!!!!!')
})

const server = app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})

if (import.meta.hot) {
  import.meta.hot.on("vite:beforeFullReload", () => {
    server.close();
  });
	// import.meta.hot.accept(() => {
  //   console.log("hot relad callback!!");
	// 	//await app.close();
	// });
}