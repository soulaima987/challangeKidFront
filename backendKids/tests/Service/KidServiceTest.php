<?php

namespace App\Tests\Service;

use App\Entity\Category;
use App\Entity\Challenge;
use App\Entity\Kid;
use App\Service\KidService;
use PHPUnit\Framework\TestCase;

class KidServiceTest extends TestCase
{
    public function testScoreChallenge()
    {
        $kid = new Kid();
        $challenge = new Challenge();

        $kid->addInterest(new Category('Arts'));
        $kid->addInterest(new Category('Music'));

        $challenge->addCategory(new Category('Music'));
        $challenge->addCategory(new Category('Arts'));
        $challenge->addCategory(new Category('Cuisine'));

        $kidService = new KidService();
        $score = $kidService->scoreChallenge($kid, $challenge);

        $this->assertEquals(2, $score);
    }
}
