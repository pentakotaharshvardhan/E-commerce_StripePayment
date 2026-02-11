const express = require("express");
const cors = require("cors");
require("dotenv").config();

const app = express();
app.use(cors());
app.use(express.json());

const stripe = require("stripe")(process.env.STRIPE_SECRET_KEY);

app.post("/create-payment-intent", async (req, res) => {
  const { amount } = req.body;

  const paymentIntent = await stripe.paymentIntents.create({
    amount,
    currency: "inr",
  });

  res.json({
    clientSecret: paymentIntent.client_secret,
  });
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
