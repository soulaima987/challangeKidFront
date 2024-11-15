<?php

namespace App\Repository;

use App\Entity\Challenge;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @extends ServiceEntityRepository<Challenge>
 */
class ChallengeRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, Challenge::class);
    }

    public function findChallengesForKid($kidId, $limit = 10)
    {
        $qb = $this->createQueryBuilder('c')
            ->leftJoin('c.categories', 'cat')
            ->leftJoin('App\Entity\Kid', 'k', 'WITH', 'k MEMBER OF c.categories')
            ->where('k.id = :kidId')
            ->setParameter('kidId', $kidId)
            ->addSelect('COUNT(cat.id) as HIDDEN relevance_score')
            ->groupBy('c.id')
            ->orderBy('relevance_score', 'DESC')
            ->setMaxResults($limit);

        return $qb->getQuery()->getResult();
    }

    public function findChallengeIdsByCoach(int $coachId): array
    {
        return $this->createQueryBuilder('c')
            ->select('c.id')
            ->andWhere('c.coach = :coachId')
            ->setParameter('coachId', $coachId)
            ->getQuery()
            ->getResult();
    }



    //    /**
    //     * @return Challenge[] Returns an array of Challenge objects
    //     */
    //    public function findByExampleField($value): array
    //    {
    //        return $this->createQueryBuilder('c')
    //            ->andWhere('c.exampleField = :val')
    //            ->setParameter('val', $value)
    //            ->orderBy('c.id', 'ASC')
    //            ->setMaxResults(10)
    //            ->getQuery()
    //            ->getResult()
    //        ;
    //    }

    //    public function findOneBySomeField($value): ?Challenge
    //    {
    //        return $this->createQueryBuilder('c')
    //            ->andWhere('c.exampleField = :val')
    //            ->setParameter('val', $value)
    //            ->getQuery()
    //            ->getOneOrNullResult()
    //        ;
    //    }
}
