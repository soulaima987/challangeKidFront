<?php

namespace App\Controller;

use App\Entity\Kid;
use App\Entity\KidParent;
use App\Form\KidParentType;
use App\Form\UserPasswordType;
use App\Repository\KidParentRepository;
use App\Service\KidParentService;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use OpenApi\Attributes as OA;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;

#[Route('/api/kidParent')]
#[OA\Tag(name: 'Parent')]
class KidParentController extends AbstractController
{
    private $kidParentService;
    private $passwordHasher;
    public function __construct(UserPasswordHasherInterface $passwordHasher, KidParentService $kidParentService)
    {
        $this->passwordHasher = $passwordHasher;
        $this->kidParentService = $kidParentService;
    }
    #[Route('/', name: 'kid_parent_index', methods: ['GET'])]
    public function index(KidParentRepository $kidParentRepository): JsonResponse
    {
        $listJson = [];
        $list = $kidParentRepository->findAll();
        foreach ($list as $key => $value) {
            $listJson[$key] = $this->kidParentService->kidParentToJson($value);
        }
        return new JsonResponse($listJson);
    }

    #[Route('/{id}', name: 'kid_parent_show', methods: ['GET'])]
    public function show($id, KidParentRepository $kidParentRepository): JsonResponse
    {
        $kid = $kidParentRepository->find($id);
        $kid = $this->kidParentService->kidParentToJson($kid);
        return new JsonResponse($kid);
    }

    #[Route('/{id}/changePassword', name: 'kid_parent_edit', methods: ['PUT'])]
    #[OA\RequestBody(
        required: true,
        content: new OA\JsonContent(
            type: Object::class,
            example: [
                "password" => "teeeeeeessst",
            ]
        )
    )]
    public function changePassword($id, Request $request, KidParentRepository $kidParentRepository, EntityManagerInterface $entityManager): JsonResponse
    {
        $kidParent = $kidParentRepository->find($id);
        $data = json_decode($request->getContent(), true);
        $form = $this->createForm(UserPasswordType::class, $kidParent);
        $form->submit($data);

        if ($form->isSubmitted()) {

            $hashedPassword = $this->passwordHasher->hashPassword($kidParent, $kidParent->getPassword());
            $kidParent->setPassword($hashedPassword);
            $entityManager->persist($kidParent);
            $entityManager->flush();
        }

        return new JsonResponse(true);
    }

    #[Route('/delete/{id}', name: 'kid_parent_delete', methods: ['DELETE'])]
    public function delete($id, KidParentRepository $kidParentRepository, EntityManagerInterface $entityManager): Response
    {
        $kidParent = $kidParentRepository->find($id);
        if (!$kidParent) {
            throw new NotFoundHttpException('kidParent not found');
        }

        $entityManager->remove($kidParent);
        $entityManager->flush();

        return new JsonResponse(['status' => 'The kidParent has been deleted']);
    }
}
