const express = require('express');
const router = express.Router();
const controller = require('./controller/job.controller.cjs');

router.get('/', controller.getAllJobs);
router.get('/:id', controller.getJobById);
router.post('/', controller.createJob);
router.put('/:id', controller.updateJob);
router.delete('/:id', controller.deleteJob);

module.exports = router;
