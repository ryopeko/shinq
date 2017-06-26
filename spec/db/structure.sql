DROP TABLE IF EXISTS `queue_test`;
CREATE TABLE `queue_test` (
  `job_id` varchar(255) NOT NULL,
  `title` varchar(255),
  `enqueued_at` datetime NOT NULL
) ENGINE=QUEUE;
