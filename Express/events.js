const express = require('express');

function createRouter(db) {
  const router = express.Router();
//  const owner = '';
const owner = req.user.email;
  // the routes are defined here

  router.get('/event', function (req, res, next) {
  db.query(
    'SELECT * FROM animated_series',[],
    (error, results) => {
      if (error) {
        console.log(error);
        res.status(500).json({status: 'error'});
      } else {
        res.status(200).json(results);
      }
    }
  );
});


router.post('/event', (req, res, next) => {
  const owner = req.user.email;
  // db.query() code
});

router.get('/event', function (req, res, next) {
  const owner = req.user.email;
  // db.query() code
});

router.put('/event/:id', function (req, res, next) {
  const owner = req.user.email;
  // db.query() code
});

router.delete('/event/:id', function (req, res, next) {
  const owner = req.user.email;
  // db.query() code
});
  return router;
}

module.exports = createRouter;