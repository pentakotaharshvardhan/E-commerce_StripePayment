const express = require("express");
const Stripe = require("stripe");
const cors = require("cors");

const app = express();
app.use(cors());
app.use(express.json());

require('dotenv').config();

const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY);
app.post("/create-payment-intent", async (req, res) => {
  const { amount } = req.body;

  const paymentIntent = await stripe.paymentIntents.create({
    amount: amount, // amount in paise/cents
    currency: "inr",
    payment_method_types: ["card"],
  });

  res.json({
    clientSecret: paymentIntent.client_secret,
  });
});

app.listen(3000, () => console.log("Server running"));
